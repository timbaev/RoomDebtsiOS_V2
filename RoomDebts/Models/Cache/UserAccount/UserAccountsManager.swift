//
//  UserAccountsManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserAccountsManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[UserAccount]> { get }
    var objectsAppendedEvent: Event<[UserAccount]> { get }
    var objectsUpdatedEvent: Event<[UserAccount]> { get }
    var objectsChangedEvent: Event<[UserAccount]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> UserAccount
    func firstOrNew() -> UserAccount

    func lastOrNew(withUID uid: Int64) -> UserAccount
    func lastOrNew() -> UserAccount

    func first(withUID uid: Int64) -> UserAccount?
    func first() -> UserAccount?

    func last(withUID uid: Int64) -> UserAccount?
    func last() -> UserAccount?

    func fetch(withUID uid: Int64) -> [UserAccount]
    func fetch() -> [UserAccount]

    func count(withUID uid: Int64) -> Int
    func count() -> Int

    func clear(withUID uid: Int64)
    func clear()

    func remove(userAccount: UserAccount)

    func append(withUID uid: Int64) -> UserAccount
    func append() -> UserAccount

    func startObserving()
    func stopObserving()
}

// MARK: -

extension UserAccountsManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> UserAccount {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }

    func firstOrNew() -> UserAccount {
        return self.first() ?? self.append()
    }

    func lastOrNew(withUID uid: Int64) -> UserAccount {
        return self.last(withUID: uid) ?? self.append(withUID: uid)
    }

    func lastOrNew() -> UserAccount {
        return self.last() ?? self.append()
    }
}
