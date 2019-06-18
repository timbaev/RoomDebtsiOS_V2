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
            let statusTextColor: UIColor

            switch check.status {
            case .some(.accepted):
                statusTextColor = Colors.green

            case .some(.calculated):
                statusTextColor = Colors.darkOrange

            case .some(.notCalculated):
                statusTextColor = Colors.white.withAlphaComponent(0.69)

            case .some(.rejected):
                statusTextColor = Colors.red

            case .some(.closed):
                statusTextColor = Colors.green

            case .none:
                statusTextColor = Colors.white.withAlphaComponent(0.69)
            }

            let price = String(format: "%.2f₽", check.totalSum)

            let dateTime: String?

            if let date = check.date {
                dateTime = CheckDateFormatter.shared.string(from: date)
            } else {
                dateTime = nil
            }

            return CheckViewModel(imageURL: check.imageURL, store: check.store, status: check.status?.title, rejectStatus: nil, price: price, dateTime: dateTime, address: check.address, statusTextColor: statusTextColor)
        }

        self.viewController.displayChecks(with: checkViewModels)
    }

    func stopRefreshing() {
        self.viewController.endRefreshing()
    }
}
