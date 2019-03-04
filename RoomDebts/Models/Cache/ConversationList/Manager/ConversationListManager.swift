//
//  ConversationListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 01/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[ConversationList]> { get }
    var objectsAppendedEvent: Event<[ConversationList]> { get }
    var objectsUpdatedEvent: Event<[ConversationList]> { get }
    var objectsChangedEvent: Event<[ConversationList]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: ConversationListType) -> ConversationList
    func firstOrNew() -> ConversationList

    func lastOrNew(withListType listType: ConversationListType) -> ConversationList
    func lastOrNew() -> ConversationList

    func first(withListType listType: ConversationListType) -> ConversationList?
    func first() -> ConversationList?

    func last(withListType listType: ConversationListType) -> ConversationList?
    func last() -> ConversationList?

    func fetch(withListType listType: ConversationListType) -> [ConversationList]
    func fetch() -> [ConversationList]

    func count(withListType listType: ConversationListType) -> Int
    func count() -> Int

    func clear(withListType listType: ConversationListType)
    func clear()

    func remove(conversationList: ConversationList)

    func append(withListType listType: ConversationListType) -> ConversationList
    func append() -> ConversationList
}

// MARK: -

extension ConversationListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: ConversationListType) -> ConversationList {
        return self.first(withListType: listType) ?? self.append(withListType: listType)
    }

    func firstOrNew() -> ConversationList {
        return self.first() ?? self.append()
    }

    func lastOrNew(withListType listType: ConversationListType) -> ConversationList {
        return self.last(withListType: listType) ?? self.append(withListType: listType)
    }

    func lastOrNew() -> ConversationList {
        return self.last() ?? self.append()
    }
}
