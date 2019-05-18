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
    }

    // MARK: -

    private enum Constants {

        // MARK: - Type Properties

        static let productTableCellIdentifier = "ProductCell"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

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

    // MARK: - Instance Methods

    @objc private func onTableRefreshControlRequested(_ sender: Any) {
        Log.i()

        self.refreshProductList()
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

    private func configureTableRefreshControl() {
        let tableRefreshControl = UIRefreshControl()

        tableRefreshControl.tintColor = Colors.white

        tableRefreshControl.addTarget(self,
                                      action: #selector(self.onTableRefreshControlRequested(_:)),
                                      for: .valueChanged)

        self.tableView.refreshControl = tableRefreshControl
        self.tableRefreshControl = tableRefreshControl
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let check = self.check {
            self.apply(check: check)
            self.apply(productListType: .check(uid: check.uid))
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
