//
//  ChecksPresenter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

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

    func showLoadingState(with title: String, message: String) {
        self.viewController.displayLoadingState(with: title, message: message)
    }

    func showEmptyState(with message: String, actionTitle: String) {
        self.viewController.displayEmptyState(with: message, actionTitle: actionTitle)
    }

    func showEmptyState(with image: UIImage, title: String, message: String, actionTitle: String) {
        self.viewController.displayEmptyState(with: image, title: title, message: message, actionTitle: actionTitle)
    }

    func hideEmptyState() {
        self.viewController.hideEmptyState()
    }

    func showChecks(with list: CheckList) {
        let checkViewModels = list.checks.map { check -> CheckViewModel in
            let status: String?

            switch check.status {
            case .some(.accepted):
                status = "Accepted".localized()

            case .some(.calculated):
                status = "Calculated".localized()

            case .some(.notCalculated):
                status = "Not calculated".localized()

            case .some(.rejected):
                status = "Rejected".localized()

            case .none:
                status = nil
            }

            let price = String(format: "%.2f₽", check.totalSum)

            let dateTime: String?

            if let date = check.date {
                dateTime = CheckDateFormatter.shared.string(from: date)
            } else {
                dateTime = nil
            }

            return CheckViewModel(imageURL: check.imageURL, store: check.store, status: status, rejectStatus: nil, price: price, dateTime: dateTime, address: check.address)
        }

        self.viewController.displayChecks(with: checkViewModels)
    }

    func stopRefreshing() {
        self.viewController.endRefreshing()
    }
}
