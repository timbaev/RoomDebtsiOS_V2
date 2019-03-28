//
//  MockCacheContextFactory.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockCacheContextFactory: CacheContextFactory {

    // MARK: - Instance Methods

    func createCacheContext(storageContext: StorageContext, model: CacheModel, parent: CacheContext?) -> CacheContext {
        return MockCacheContext(storageContext: storageContext, model: model, parent: parent)
    }
}
