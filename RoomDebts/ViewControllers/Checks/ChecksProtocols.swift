//
//  ChecksProtocols.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

protocol ChecksDataPassing: AnyObject {

    // MARK: - Instance Properties

    var dataStore: ChecksDataStore! { get }
}

protocol ChecksDataStore: AnyObject { }

protocol ChecksBusinessLogic: AnyObject {

    // MARK: - Instance Methods

    func createCheck(with metadata: String)
    func fetchChecks()
}

protocol ChecksPresentationLogic: AnyObject {

    // MARK: - Instance Methods

    func showMessage(with error: WebError)
    func showMessage(with title: String, message: String)

    func showLoadingIndicator()
    func hideLoadingIndicator()

    func showLoadingState(with title: String, message: String)
    func showEmptyState(with message: String, actionTitle: String)
    func showEmptyState(with image: UIImage, title: String, message: String, actionTitle: String)
    func hideEmptyState()

    func showChecks(with list: CheckList)

    func stopRefreshing()
}

protocol ChecksRoutingLogic: AnyObject {

    // MARK: - Instance Methods

    func showQRScanner()
}

protocol ChecksViewDisplayLogic: AnyObject {

    // MARK: - Instance Methods

    func displayMessage(with error: WebError)
    func displayMessage(with title: String, message: String)

    func displayLoadingIndicator()
    func hideLoadingIndicator()

    func displayLoadingState(with title: String, message: String)
    func displayEmptyState(with message: String, actionTitle action: String)
    func displayEmptyState(with image: UIImage, title: String, message: String, actionTitle: String)
    func hideEmptyState()

    func displayChecks(with viewModels: [CheckViewModel])

    func endRefreshing()
}
