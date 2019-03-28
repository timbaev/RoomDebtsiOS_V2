//
//  MockStorageManager.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockStorageManager: StorageManager {

    // MARK: - Instance Properties

    private(set) var firstCalled = false
    private(set) var lastCalled = false
    private(set) var removeCalled = false
    private(set) var appendCalled = false
    private(set) var fetchCalled = false
    private(set) var countCalled = false
    private(set) var clearCalled = false

    // MARK: -

    var context: StorageContext

    // MARK: - Initializers

    init(context: StorageContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    func first<Object>(with fetchRequest: StorageFetchRequest<Object>) -> Object? where Object : StorageObject {
        self.firstCalled = true

        return nil
    }

    func last<Object>(with fetchRequest: StorageFetchRequest<Object>) -> Object? where Object : StorageObject {
        self.lastCalled = true

        return nil
    }

    func remove<Object>(object: Object) where Object : StorageObject {
        self.removeCalled = true
    }

    func append<Object>() -> Object? where Object : StorageObject {
        self.appendCalled = true

        return nil
    }

    func fetch<Object>(with fetchRequest: StorageFetchRequest<Object>) -> [Object] where Object : StorageObject {
        self.fetchCalled = true

        return []
    }

    func count<Object>(with fetchRequest: StorageFetchRequest<Object>) -> Int where Object : StorageObject {
        self.countCalled = true

        return 0
    }

    func clear<Object>(with fetchRequest: StorageFetchRequest<Object>) where Object : StorageObject {
        self.clearCalled = true
    }
}
