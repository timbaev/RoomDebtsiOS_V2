//
//  DebtListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 14/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol DebtListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[DebtList]> { get }
    var objectsAppendedEvent: Event<[DebtList]> { get }
    var objectsUpdatedEvent: Event<[DebtList]> { get }
    var objectsChangedEvent: Event<[DebtList]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: DebtListType) -> DebtList
    func firstOrNew() -> DebtList

    func lastOrNew(withListType listType: DebtListType) -> DebtList
    func lastOrNew() -> DebtList

    func first(withListType listType: DebtListType) -> DebtList?
    func first() -> DebtList?

    func last(withListType listType: DebtListType) -> DebtList?
    func last() -> DebtList?

    func fetch(withListType listType: DebtListType) -> [DebtList]
    func fetch() -> [DebtList]

    func count(withListType listType: DebtListType) -> Int
    func count() -> Int

    func clear(withListType listType: DebtListType)
    func clear()

    func remove(debtList: DebtList)

    func append(withListType listType: DebtListType) -> DebtList
    func append() -> DebtList

    func startObserving()
    func stopObserving()
}

// MARK: -

extension DebtListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: DebtListType) -> DebtList {
        return self.first(withListType: listType) ?? self.append(withListType: listType)
    }

    func firstOrNew() -> DebtList {
        return self.first() ?? self.append()
    }

    func lastOrNew(withListType listType: DebtListType) -> DebtList {
        return self.last(withListType: listType) ?? self.append(withListType: listType)
    }

    func lastOrNew() -> DebtList {
        return self.last() ?? self.append()
    }
}
