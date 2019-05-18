//
//  ChecksRouter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

final class ChecksRouter: ChecksRoutingLogic, ChecksDataPassing {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showQRScanner = "ShowQRScanner"
        static let showProducts = "ShowProducts"
    }

    // MARK: - Instance Properties

    weak var viewController: ChecksViewController!

    var dataStore: ChecksDataStore!

    // MARK: - Instance Methods

    func showQRScanner() {
        self.viewController.performSegue(withIdentifier: Segues.showQRScanner, sender: self.viewController)
    }

    func showProducts(with indexPath: IndexPath) {
        self.viewController.performSegue(withIdentifier: Segues.showProducts,
                                         sender: self.dataStore.checks[indexPath.row])
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dictionaryReceiver: DictionaryReceiver?

        if let navigationController = segue.destination as? UINavigationController {
            dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
        } else {
            dictionaryReceiver = segue.destination as? DictionaryReceiver
        }

        switch segue.identifier {
        case Segues.showProducts:
            guard let check = sender as? Check else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["check": check])
            }

        default:
            break
        }
    }
}
