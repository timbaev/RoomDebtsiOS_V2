//
//  DebtManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol DebtManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[Debt]> { get }
    var objectsAppendedEvent: Event<[Debt]> { get }
    var objectsUpdatedEvent: Event<[Debt]> { get }
    var objectsChangedEvent: Event<[Debt]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Debt

    func first(withUID uid: Int64) -> Debt?

    func append(withUID uid: Int64) -> Debt
    func append() -> Debt

    func clear()
    func clear(withUID uid: Int64)

    func startObserving()
    func stopObserving()
}

// MARK: -

extension DebtManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Debt {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }
}
