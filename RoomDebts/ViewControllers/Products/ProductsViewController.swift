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

    private var shouldApplyData = true

    // MARK: - Instance Methods

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let check = self.check {
            self.apply(check: check)
        }
    }
}

extension ProductsViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String : Any]) {
        guard let check = dictionary["check"] as? Check else {
            return
        }

        self.apply(check: check)
    }
}
