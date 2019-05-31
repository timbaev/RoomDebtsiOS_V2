//
//  UserListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[UserList]> { get }
    var objectsAppendedEvent: Event<[UserList]> { get }
    var objectsUpdatedEvent: Event<[UserList]> { get }
    var objectsChangedEvent: Event<[UserList]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: UserListType) -> UserList
    func firstOrNew() -> UserList

    func lastOrNew(withListType listType: UserListType) -> UserList
    func lastOrNew() -> UserList

    func first(withListType listType: UserListType) -> UserList?
    func first() -> UserList?

    func last(withListType listType: UserListType) -> UserList?
    func last() -> UserList?

    func fetch(withListType listType: UserListType) -> [UserList]
    func fetch() -> [UserList]

    func count(withListType listType: UserListType) -> Int
    func count() -> Int

    func clear(withListType listType: UserListType)
    func clear()

    func remove(userList: UserList)

    func append(withListType listType: UserListType) -> UserList
    func append() -> UserList

    func startObserving()
    func stopObserving()
}

// MARK: -

extension UserListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: UserListType) -> UserList {
        return self.first(withListType: listType) ?? self.append(withListType: listType)
    }

    func firstOrNew() -> UserList {
        return self.first() ?? self.append()
    }

    func lastOrNew(withListType listType: UserListType) -> UserList {
        return self.last(withListType: listType) ?? self.append(withListType: listType)
    }

    func lastOrNew() -> UserList {
        return self.last() ?? self.append()
    }
}
