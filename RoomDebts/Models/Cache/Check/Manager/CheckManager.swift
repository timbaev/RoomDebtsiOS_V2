//
//  CheckManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[Check]> { get }
    var objectsAppendedEvent: Event<[Check]> { get }
    var objectsUpdatedEvent: Event<[Check]> { get }
    var objectsChangedEvent: Event<[Check]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Check

    func first(withUID uid: Int64) -> Check?

    func append(withUID uid: Int64) -> Check
    func append() -> Check

    func clear()
    func clear(withUID uid: Int64)

    func startObserving()
    func stopObserving()
}

// MARK: -

extension CheckManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Check {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }
}
