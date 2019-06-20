//
//  ProductsViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PromiseKit

class ProductsViewController: LoggedViewController, EmptyStateViewable, ErrorMessagePresenter, NVActivityIndicatorViewable {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let unauthorized = "Unauthorized"
        static let showParticipants = "ShowParticipants"
        static let showReviews = "ShowReviews"
    }

    // MARK: -

    private enum Constants {

        // MARK: - Type Properties

        static let productTableCellIdentifier = "ProductCell"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var calculateButton: PrimaryButton!
    @IBOutlet private weak var reviewsButton: PrimaryButton!

    private weak var tableRefreshControl: UIRefreshControl!

    // MARK: -

    private var check: Check?

    private var productList: ProductList!
    private var productlistType: ProductListType = .unknown

    private var shouldApplyData = true
    private var isRefreshingData = false

    private var selectedProducts: [Product.UID: [User.UID]] = [:]

    private var isUserCreator: Bool {
        return self.check?.creator?.uid == Services.userAccount?.uid
    }

    // MARK: - EmptyStateViewable

    var emptyStateContainerView = UIView()
    var emptyStateView = EmptyStateView()

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromCheckEvents()
        self.unsubscribeFromProductListEvents()
    }

    // MARK: - Instance Methods

    @objc private func onTableRefreshControlRequested(_ sender: Any) {
        Log.i()

        self.refreshProductList()
    }

    @objc private func onParticipantsBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        guard let check = self.check else {
            return
        }

        self.performSegue(withIdentifier: Segues.showParticipants, sender: check)
    }

    @IBAction private func onCalculateButtonTouchUpInside(_ sender: PrimaryButton) {
        Log.i()

        guard let check = self.check else {
            return
        }

        if check.status == .some(.calculated) || check.status == .some(.rejected) {
            UIAlertController.Builder()
                .preferredStyle(.actionSheet)
                .withTitle("Recalculate".localized())
                .withMessage("Previous calculation results will be lost and approvals will be cancel.".localized())
                .addDefaultAction(withTitle: "Recalculate".localized(), handler: { [unowned self] action in
                    self.calculate(check: check)
                })
                .addCancelAction()
                .show(in: self)
        }
    }

    @IBAction private func onReviewsButtonTouchUpInside(_ sender: PrimaryButton) {
        Log.i()

        self.performSegue(withIdentifier: Segues.showReviews, sender: self)
    }

    // MARK: -

    private func handle(stateError error: Error, retryHandler: (() -> Void)? = nil) {
        let action = EmptyStateAction(title: "Try Again".localized(), onClicked: {
            retryHandler?()
        })

        switch error as? WebError {
        case .some(.connection), .some(.timeOut):
            if self.productList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorInternet.pdf"),
                                    title: Messages.internetConncetionTitle,
                                    message: Messages.internetConnection,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.internetConncetionTitle, message: Messages.internetConnection)
            }

        case .some(.badRequest):
            if let webError = error as? WebError, let message = webError.message {
                if self.productList?.isEmpty ?? true {
                    self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                        title: Messages.unknownErrorTitle,
                                        message: message,
                                        action: action)
                } else {
                    self.showMessage(withTitle: nil, message: message)
                }
            } else {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: Messages.unknownErrorTitle,
                                    message: Messages.unknownError,
                                    action: action)
            }

        case .some(.badRequest):
            self.performSegue(withIdentifier: Segues.unauthorized, sender: self)

        default:
            if self.productList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: Messages.unknownErrorTitle,
                                    message: Messages.unknownError,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.unknownErrorTitle, message: Messages.unknownError)
            }
        }
    }

    // MARK: -

    private func calculate(check: Check) {
        Log.i()

        self.startAnimating()

        firstly {
            Services.checkService.calculate(check: check.uid, selectedProducts: self.selectedProducts)
        }.ensure {
            self.stopAnimating()
        }.done { checkUserList in
            self.performSegue(withIdentifier: Segues.showReviews, sender: checkUserList)
        }.catch { error in
            self.handle(stateError: error)
        }
    }

    private func refreshProductList() {
        Log.i()

        guard let check = self.check else {
            return
        }

        self.isRefreshingData = true

        if !self.tableRefreshControl.isRefreshing {
            if (self.productList.isEmpty) || (!self.emptyStateContainerView.isHidden) {
                self.showLoadingState(with: "Loading products".localized(),
                                      message: "We are loading list of products. Please wait a bit".localized())
            }
        }

        Services.productService.fetch(with: check.uid, result: { [weak self] result in
            guard let `self` = self else {
                return
            }

            switch result {
            case .success(let productList):
                self.apply(productList: productList)

            case .failure(let error):
                self.handle(stateError: error, retryHandler: { [weak self] in
                    self?.refreshProductList()
                })
            }
        })
    }

    // MARK: -

    private func apply(check: Check) {
        Log.i(check.uid)

        self.check = check

        if self.isViewLoaded {
            self.navigationItem.title = check.store

            switch check.status {
            case .some(.calculated), .some(.rejected), .some(.accepted):
                self.calculateButton.setTitle("Recalculate".localized(), for: .normal)

            case .some(.notCalculated):
                self.reviewsButton.isHidden = true

            case .some(.closed):
                self.calculateButton.isHidden = true

            case .none:
                self.calculateButton.isHidden = true
                self.reviewsButton.isHidden = true
            }

            if !self.isUserCreator {
                self.calculateButton.isHidden = true
            }

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    private func apply(productList: ProductList, canShowState: Bool = true) {
        Log.i(productList.count)

        self.productList = productList

        productList.allProducts.forEach { product in
            self.selectedProducts[product.uid] = product.selectedUsers.map { $0.uid }
        }

        self.updateCalculateButtonState()

        if productList.isEmpty && canShowState {
            self.showNoDataState(with: "Products not exists".localized())
        } else {
            self.hideEmptyState()
        }

        if self.tableRefreshControl.isRefreshing {
            self.tableRefreshControl.endRefreshing()
        }

        self.isRefreshingData = false

        self.tableView.reloadData()

        self.shouldApplyData = false
    }

    private func apply(productListType: ProductListType) {
        Log.i(productListType.checkUID)

        self.productlistType = productListType

        self.apply(productList: Services.cacheViewContext.productListManager.firstOrNew(withListType: productListType))

        self.refreshProductList()
    }

    // MARK: -

    private func subscribeToCheckEvents() {
        self.unsubscribeFromCheckEvents()

        let checkManager = Services.cacheViewContext.checkManager

        checkManager.objectsChangedEvent.connect(self, handler: { [weak self] checks in
            guard let viewController = self else {
                return
            }

            viewController.check = checks.first
            viewController.shouldApplyData = true
        })

        checkManager.startObserving()
    }

    private func unsubscribeFromCheckEvents() {
        Services.cacheViewContext.checkManager.objectsChangedEvent.disconnect(self)
    }

    private func subscribeToProductListEvents() {
        self.unsubscribeFromProductListEvents()

        let productListManager = Services.cacheViewContext.productListManager

        productListManager.objectsChangedEvent.connect(self, handler: { [weak self] productLists in
            guard let viewController = self else {
                return
            }

            if viewController.view.window == nil {
                viewController.shouldApplyData = true
            }
        })

        productListManager.startObserving()
    }

    private func unsubscribeFromProductListEvents() {
        Services.cacheViewContext.productListManager.objectsChangedEvent.disconnect(self)
    }

    // MARK: -

    private func updateCalculateButtonState() {
        let productUIDs = self.productList.allProducts.map { $0.uid }
        let userUIDs = self.productList.users.map { $0.uid }

        let selectedProductUIDs = Array(self.selectedProducts.filter { !$1.isEmpty }.keys)
        let selectedUserUIDs = self.selectedProducts.values.flatMap { $0 }.unique()

        self.calculateButton.isEnabled = (productUIDs.sorted().elementsEqual(selectedProductUIDs.sorted()) && userUIDs.sorted().elementsEqual(selectedUserUIDs.sorted()))
    }

    // MARK: -

    private func configure(productTableCell cell: ProductTableViewCell, at indexPath: IndexPath) {
        let product = self.productList[indexPath.row]
        let checkUsers = self.productList.users
        let userIsCreator = (self.check?.creator?.uid == Services.userAccount?.uid)
        let checkIsClosed = (self.check?.status == .some(.closed))

        let viewModel = ProductViewModel(product: product,
                                         checkUsers: checkUsers,
                                         allowUserSelection: !checkIsClosed && userIsCreator)

        cell.configure(data: viewModel)

        cell.onSelectedProductUserIndexPathsUpdated = { [unowned self] indexPaths in
            self.selectedProducts[product.uid] = indexPaths.map { checkUsers[$0.row].uid }

            product.selectedUsers = indexPaths.map { checkUsers[$0.row] }

            self.updateCalculateButtonState()
        }
    }

    // MARK: -

    private func configureTableRefreshControl() {
        let tableRefreshControl = UIRefreshControl()

        tableRefreshControl.tintColor = Colors.white

        tableRefreshControl.addTarget(self,
                                      action: #selector(self.onTableRefreshControlRequested(_:)),
                                      for: .valueChanged)

        self.tableView.refreshControl = tableRefreshControl
        self.tableRefreshControl = tableRefreshControl
    }

    private func configureParticipantsBarButtonItem() {
        let participantsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ParticipantsIcon.pdf"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(self.onParticipantsBarButtonItemTouchUpInside(_:)))

        self.navigationItem.rightBarButtonItem = participantsBarButtonItem
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableRefreshControl()
        self.configureParticipantsBarButtonItem()

        self.subscribeToCheckEvents()
        self.subscribeToProductListEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let check = self.check {
            self.apply(check: check)
            self.apply(productListType: .check(uid: check.uid))
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let footerView = self.tableView.tableFooterView else {
            return
        }

        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
        }

        self.tableView.tableFooterView = footerView
        self.tableView.layoutIfNeeded()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let dictionaryReceiver: DictionaryReceiver?

        if let navigationController = segue.destination as? UINavigationController {
            dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
        } else {
            dictionaryReceiver = segue.destination as? DictionaryReceiver
        }

        switch segue.identifier {
        case Segues.showParticipants:
            guard let check = sender as? Check else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["check": check])
            }

        case Segues.showReviews:
            guard let check = self.check else {
                fatalError()
            }

            var dictionary: [String: Any] = ["check": check]

            if let checkUserList = sender as? CheckUserList {
                dictionary["checkUserList"] = checkUserList
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: dictionary)
            }

        default:
            break
        }
    }
}

// MARK: - DictionaryReceiver

extension ProductsViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let check = dictionary["check"] as? Check else {
            return
        }

        self.apply(check: check)
    }
}

// MARK: - UITableViewDataSource

extension ProductsViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.productTableCellIdentifier, for: indexPath)

        self.configure(productTableCell: cell as! ProductTableViewCell, at: indexPath)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProductsViewController: UITableViewDelegate { }
