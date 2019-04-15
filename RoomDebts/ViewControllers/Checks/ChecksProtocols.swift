//
//  ChecksProtocols.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ChecksDataPassing: AnyObject {

    // MARK: - Instance Properties

    var dataStore: ChecksDataStore! { get }
}

protocol ChecksDataStore: AnyObject { }

protocol ChecksBusinessLogic: AnyObject {

    // MARK: - Instance Methods

    func createCheck(with metadata: String)
}

protocol ChecksPresentationLogic: AnyObject {

    // MARK: - Instance Methods

    func showMessage(with error: WebError)
    func showMessage(with title: String, message: String)

    func showLoadingIndicator()
    func hideLoadingIndicator()
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
}
