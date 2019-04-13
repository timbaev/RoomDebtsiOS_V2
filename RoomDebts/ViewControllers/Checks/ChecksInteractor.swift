//
//  ChecksInteractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

final class ChecksInteractor: ChecksBusinessLogic, ChecksDataStore {

    // MARK: - Instance Properties

    var presenter: ChecksPresentationLogic!
    var checkService: CheckService!

    // MARK: - ChecksBusinessLogic
}
