//
//  ChecksRouter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

final class ChecksRouter: ChecksRoutingLogic, ChecksDataPassing {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showQRScanner = "ShowQRScanner"
    }

    // MARK: - Instance Properties

    weak var viewController: ChecksViewController!

    var dataStore: ChecksDataStore!

    // MARK: - Instance Methods

    func showQRScanner() {
        self.viewController.performSegue(withIdentifier: Segues.showQRScanner, sender: self.viewController)
    }
}
