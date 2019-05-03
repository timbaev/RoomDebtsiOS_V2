//
//  ProductsViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ProductsViewController: LoggedViewController, EmptyStateViewable {

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    private weak var tableRefreshControl: UIRefreshControl!

    // MARK: -

    private var check: Check?

    private var productList: ProductList!
    private var productlistType: ProductListType = .unknown

    private var shouldApplyData = true
    private var isRefreshingData = false

    // MARK: - Instance Methods

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

    private func apply(productList: ProductList) {
        Log.i(productList.count)
    }

    private func apply(productListType: ProductListType) {
        Log.i(productListType.checkUID)

        self.productlistType = productListType

        if let productList = Services.cacheViewContext.productListManager.first(withListType: productListType) {
            self.apply(productList: productList)
        }

        
    }

    // MARK: - UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let check = self.check {
            self.apply(check: check)
        }
    }
}

extension ProductsViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let check = dictionary["check"] as? Check else {
            return
        }

        self.apply(check: check)
    }
}
