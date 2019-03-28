//
//  MockConversationListManager.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockConversationListManager: ConversationListManager {

    // MARK: - Instance Properties

    var context: CacheContext

    var objectsRemovedEvent = Event<[ConversationList]>()
    var objectsAppendedEvent = Event<[ConversationList]>()
    var objectsUpdatedEvent = Event<[ConversationList]>()
    var objectsChangedEvent = Event<[ConversationList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    func first(withListType listType: ConversationListType) -> ConversationList? {
        return nil
    }

    func first() -> ConversationList? {
        return nil
    }

    func last(withListType listType: ConversationListType) -> ConversationList? {
        return nil
    }

    func last() -> ConversationList? {
        return nil
    }

    func fetch(withListType listType: ConversationListType) -> [ConversationList] {
        return []
    }

    func fetch() -> [ConversationList] {
        return []
    }

    func count(withListType listType: ConversationListType) -> Int {
        return 0
    }

    func count() -> Int {
        return 0
    }

    func clear(withListType listType: ConversationListType) {

    }

    func clear() {

    }

    func remove(conversationList: ConversationList) {

    }

    func append(withListType listType: ConversationListType) -> ConversationList {
        return MockConversationList()
    }

    func append() -> ConversationList {
        return MockConversationList()
    }
}
