//
//  MockCacheModel.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockCacheModel: CacheModel {

    // MARK: - Instance Properties

    var storageModel: StorageModel = MockStorageModel(identifier: "Test")
    var contextFactory: CacheContextFactory = MockCacheContextFactory()
    var managerFactory: CacheManagerFactory = MockCacheManagerFactory()

    // MARK: -

    private(set) lazy var viewContext: CacheContext = { [unowned self] in
        return self.contextFactory.createCacheContext(storageContext: self.storageModel.viewContext, model: self, parent: nil)
    }()
}
