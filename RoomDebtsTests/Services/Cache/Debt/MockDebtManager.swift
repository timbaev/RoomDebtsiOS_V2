//
//  MockDebtManager.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockDebtManager: DebtManager {

    // MARK: - Instance Properties

    var context: CacheContext

    var objectsRemovedEvent = Event<[Debt]>()
    var objectsAppendedEvent = Event<[Debt]>()
    var objectsUpdatedEvent = Event<[Debt]>()
    var objectsChangedEvent = Event<[Debt]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    func first(withUID uid: Int64) -> Debt? {
        return nil
    }

    func append(withUID uid: Int64) -> Debt {
        return MockDebt()
    }

    func append() -> Debt {
        return MockDebt()
    }

    func clear() {

    }

    func clear(withUID uid: Int64) {

    }

    func startObserving() {

    }

    func stopObserving() {

    }
}
