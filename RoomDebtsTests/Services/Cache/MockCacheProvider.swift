//
//  MockCacheProvider.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockCacheProvider: CacheProvider {

    // MARK: - Instance Properties

    var isModelCaptured = false
    var model: CacheModel = MockCacheModel()
}
