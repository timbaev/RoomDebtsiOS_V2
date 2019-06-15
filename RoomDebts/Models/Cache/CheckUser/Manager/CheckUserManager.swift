//
//  CheckUserManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckUserManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[CheckUser]> { get }
    var objectsAppendedEvent: Event<[CheckUser]> { get }
    var objectsUpdatedEvent: Event<[CheckUser]> { get }
    var objectsChangedEvent: Event<[CheckUser]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> CheckUser

    func first(withUID uid: Int64) -> CheckUser?
    func first(withUserUID uid: Int64) -> CheckUser?

    func append(withUID uid: Int64) -> CheckUser
    func append() -> CheckUser

    func clear()
    func clear(withUID uid: Int64)

    func startObserving()
    func stopObserving()
}

// MARK: -

extension CheckUserManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> CheckUser {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }
}
