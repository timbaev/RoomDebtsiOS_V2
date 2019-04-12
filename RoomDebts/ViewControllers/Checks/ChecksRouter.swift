//
//  ChecksRouter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright (c) 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

final class ChecksRouter: ChecksRoutingLogic, ChecksDataPassing {

    // MARK: - Instance Properties

    weak var viewController: ChecksViewController!

    var dataStore: ChecksDataStore!
}
