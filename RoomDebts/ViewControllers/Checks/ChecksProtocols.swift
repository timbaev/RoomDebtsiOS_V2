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
}

protocol ChecksPresentationLogic: AnyObject {

    // MARK: - Instance Methods
}

protocol ChecksRoutingLogic: AnyObject { }

protocol ChecksViewDisplayLogic: AnyObject {

    // MARK: - Instance Methods
}
