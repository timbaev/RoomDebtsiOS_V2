//
//  WelcomeViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class WelcomeViewController: LoggedViewController {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        Services.cacheProvider.model.viewContext.clear()
    }
}
