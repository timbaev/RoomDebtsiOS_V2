//
//  CheckListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 15/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[CheckList]> { get }
    var objectsAppendedEvent: Event<[CheckList]> { get }
    var objectsUpdatedEvent: Event<[CheckList]> { get }
    var objectsChangedEvent: Event<[CheckList]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: CheckListType) -> CheckList
    func firstOrNew() -> CheckList

    func lastOrNew(withListType listType: CheckListType) -> CheckList
    func lastOrNew() -> CheckList

    func first(withListType listType: CheckListType) -> CheckList?
    func first() -> CheckList?

    func last(withListType listType: CheckListType) -> CheckList?
    func last() -> CheckList?

    func fetch(withListType listType: CheckListType) -> [CheckList]
    func fetch() -> [CheckList]

    func count(withListType listType: CheckListType) -> Int
    func count() -> Int

    func clear(withListType listType: CheckListType)
    func clear()

    func remove(checkList: CheckList)

    func append(withListType listType: CheckListType) -> CheckList
    func append() -> CheckList
}

// MARK: -

extension CheckListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: CheckListType) -> CheckList {
        return self.first(withListType: listType) ?? self.append(withListType: listType)
    }

    func firstOrNew() -> CheckList {
        return self.first() ?? self.append()
    }

    func lastOrNew(withListType listType: CheckListType) -> CheckList {
        return self.last(withListType: listType) ?? self.append(withListType: listType)
    }

    func lastOrNew() -> CheckList {
        return self.last() ?? self.append()
    }
}
