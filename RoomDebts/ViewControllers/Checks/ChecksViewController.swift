//
//  ChecksViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ChecksViewController: LoggedViewController, ChecksViewDisplayLogic {

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    // MARK: -

    var interactor: ChecksBusinessLogic!
    var router: ChecksRoutingLogic!

    // MARK: - ChecksViewDisplayLogic

    // MARK: - Instance Methods

    @objc private func onPlusButtonTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()
    }

    // MARK: -

    private func configurePlusBarButtonItem() {
        let plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPlusButtonTouchUpInside(_:)))

        plusBarButtonItem.tintColor = Colors.plusBarItem

        self.navigationItem.rightBarButtonItem = plusBarButtonItem
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurePlusBarButtonItem()
    }
}
