//
//  ChecksPresenter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

final class ChecksPresenter: ChecksPresentationLogic {

    // MARK: - Instance Properties

    weak var viewController: ChecksViewDisplayLogic!

    // MARK: - ChecksPresentationLogic

    func showMessage(with error: WebError) {
        self.viewController.displayMessage(with: error)
    }

    func showMessage(with title: String, message: String) {
        self.viewController.displayMessage(with: title, message: message)
    }

    func showLoadingIndicator() {
        self.viewController.displayLoadingIndicator()
    }

    func hideLoadingIndicator() {
        self.viewController.hideLoadingIndicator()
    }
}
