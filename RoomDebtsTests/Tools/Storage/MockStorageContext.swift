//
//  MockStorageContext.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockStorageContext: StorageContext {

    // MARK: - Instance Properties

    private(set) var addObserverCalled = false
    private(set) var removeObserverCalled = false
    private(set) var createMainQueueChildContextCalled = false
    private(set) var createPrivateQueueChildContextCalled = false
    private(set) var performAndWaitCalled = false
    private(set) var performCalled = false
    private(set) var rollbackCalled = false
    private(set) var saveCalled = false

    // MARK: -

    var observers: [StorageContextObserver] = []
    var model: StorageModel!
    var parent: StorageContext?

    public private(set) lazy var manager: StorageManager = { [unowned self] in
        return MockStorageManager(context: self)
    }()

    var type: StorageContextType = .mainQueue

    // MARK: - Initializers

    required init(model: StorageModel, parent: StorageContext?) {
        self.model = model
        self.parent = parent
    }

    // MARK: - Instance Methods

    func addObserver(_ observer: StorageContextObserver) {
        self.addObserverCalled = true
    }

    func removeObserver(_ observer: StorageContextObserver) {
        self.removeObserverCalled = true
    }

    func createMainQueueChildContext() -> StorageContext {
        self.createMainQueueChildContextCalled = true

        return self
    }

    func createPrivateQueueChildContext() -> StorageContext {
        self.createPrivateQueueChildContextCalled = true

        return self
    }

    func performAndWait(block: @escaping () -> Void) {
        self.performAndWaitCalled = true
    }

    func perform(block: @escaping () -> Void) {
        self.performCalled = true
    }

    func rollback() {
        self.rollbackCalled = true
    }

    func save() {
        self.saveCalled = true
    }
}
