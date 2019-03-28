//
//  MockDebtListManager.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockDebtListManager: DebtListManager {

    // MARK: - Instance Properties

    var context: CacheContext

    var objectsRemovedEvent = Event<[DebtList]>()
    var objectsAppendedEvent = Event<[DebtList]>()
    var objectsUpdatedEvent = Event<[DebtList]>()
    var objectsChangedEvent = Event<[DebtList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    func first(withListType listType: DebtListType) -> DebtList? {
        return nil
    }

    func first() -> DebtList? {
        return nil
    }

    func last(withListType listType: DebtListType) -> DebtList? {
        return nil
    }

    func last() -> DebtList? {
        return nil
    }

    func fetch(withListType listType: DebtListType) -> [DebtList] {
        return []
    }

    func fetch() -> [DebtList] {
        return []
    }

    func count(withListType listType: DebtListType) -> Int {
        return 0
    }

    func count() -> Int {
        return 0
    }

    func clear(withListType listType: DebtListType) {

    }

    func clear() {

    }

    func remove(debtList: DebtList) {

    }

    func append(withListType listType: DebtListType) -> DebtList {
        return MockDebtList()
    }

    func append() -> DebtList {
        return MockDebtList()
    }

    func startObserving() {

    }

    func stopObserving() {

    }
}
