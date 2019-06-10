//
//  CheckUserListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckUserListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[CheckUserList]> { get }
    var objectsAppendedEvent: Event<[CheckUserList]> { get }
    var objectsUpdatedEvent: Event<[CheckUserList]> { get }
    var objectsChangedEvent: Event<[CheckUserList]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: CheckUserListType) -> CheckUserList
    func firstOrNew() -> CheckUserList

    func lastOrNew(withListType listType: CheckUserListType) -> CheckUserList
    func lastOrNew() -> CheckUserList

    func first(withListType listType: CheckUserListType) -> CheckUserList?
    func first() -> CheckUserList?

    func last(withListType listType: CheckUserListType) -> CheckUserList?
    func last() -> CheckUserList?

    func fetch(withListType listType: CheckUserListType) -> [CheckUserList]
    func fetch() -> [CheckUserList]

    func count(withListType listType: CheckUserListType) -> Int
    func count() -> Int

    func clear(withListType listType: CheckUserListType)
    func clear()

    func remove(checkUserList: CheckUserList)

    func append(withListType listType: CheckUserListType) -> CheckUserList
    func append() -> CheckUserList
}

// MARK: -

extension CheckUserListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: CheckUserListType) -> CheckUserList {
        return self.first(withListType: listType) ?? self.append(withListType: listType)
    }

    func firstOrNew() -> CheckUserList {
        return self.first() ?? self.append()
    }

    func lastOrNew(withListType listType: CheckUserListType) -> CheckUserList {
        return self.last(withListType: listType) ?? self.append(withListType: listType)
    }

    func lastOrNew() -> CheckUserList {
        return self.last() ?? self.append()
    }
}
