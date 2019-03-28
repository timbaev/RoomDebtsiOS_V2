//
//  MockConversationManager.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockConversationManager: ConversationManager {

    // MARK: - Instance Properties

    var context: CacheContext

    var objectsRemovedEvent = Event<[Conversation]>()
    var objectsAppendedEvent = Event<[Conversation]>()
    var objectsUpdatedEvent = Event<[Conversation]>()
    var objectsChangedEvent = Event<[Conversation]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    func first(withUID uid: Int64) -> Conversation? {
        return nil
    }

    func append(withUID uid: Int64) -> Conversation {
        return MockConversation()
    }

    func append() -> Conversation {
        return MockConversation()
    }

    func clear() {

    }

    func clear(withUID uid: Int64) {

    }

    func startObserving() {

    }

    func stopObserving() {

    }
}
