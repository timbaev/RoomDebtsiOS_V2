//
//  ChecksViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright (c) 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ChecksViewController: LoggedViewController, ChecksViewDisplayLogic {

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    // MARK: -

    var interactor: ChecksBusinessLogic!
    var router: ChecksRoutingLogic!

    // MARK: - ChecksViewDisplayLogic

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
