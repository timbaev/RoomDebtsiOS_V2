//
//  ProductsViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ProductsViewController: LoggedViewController, EmptyStateViewable, ErrorMessagePresenter {

    // MARK: - Typealiases

    private typealias ProductCellConfigurator = TableCellConfigurator<ProductTableViewCell, ProductViewModel>

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let unauthorized = "Unauthorized"
        static let showParticipants = "ShowParticipants"
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

    private var items: [ProductCellConfigurator] = []

    private var shouldApplyData = true
    private var isRefreshingData = false

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

    // MARK: -

    private func handle(stateError error: WebError, retryHandler: (() -> Void)? = nil) {
        let action = EmptyStateAction(title: "Try Again".localized(), onClicked: {
            retryHandler?()
        })

        switch error {
        case .connection, .timeOut:
            if self.productList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorInternet.pdf"),
                                    title: Messages.internetConncetionTitle,
                                    message: Messages.internetConnection,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.internetConncetionTitle, message: Messages.internetConnection)
            }

        case .badRequest:
            if let message = error.message {
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

        case .unauthorized:
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
            case .some(.accepted):
                self.calculateButton.isHidden = true

            case .some(.calculated), .some(.rejected):
                self.calculateButton.setTitle("Recalculate".localized(), for: .normal)

            case .some(.notCalculated):
                self.reviewsButton.isHidden = true

            case .none:
                self.calculateButton.isHidden = true
                self.reviewsButton.isHidden = true
            }

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    private func apply(productList: ProductList, canShowState: Bool = true) {
        Log.i(productList.count)

        self.productList = productList

        self.items = productList.allProducts.map {
            let viewModel = ProductViewModel(product: $0, checkUsers: productList.users)

            return ProductCellConfigurator(item: viewModel)
        }

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

        switch segue.identifier {
        case Segues.showParticipants:
            guard let check = sender as? Check else {
                fatalError()
            }

            let dictionaryReceiver: DictionaryReceiver?

            if let navigationController = segue.destination as? UINavigationController {
                dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
            } else {
                dictionaryReceiver = segue.destination as? DictionaryReceiver
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["check": check])
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
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.productTableCellIdentifier, for: indexPath)

        self.items[indexPath.row].configure(cell: cell)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProductsViewController: UITableViewDelegate { }
