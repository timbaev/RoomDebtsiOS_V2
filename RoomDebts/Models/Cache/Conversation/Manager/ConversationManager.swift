//
//  ConversationManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[Conversation]> { get }
    var objectsAppendedEvent: Event<[Conversation]> { get }
    var objectsUpdatedEvent: Event<[Conversation]> { get }
    var objectsChangedEvent: Event<[Conversation]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Conversation

    func first(withUID uid: Int64) -> Conversation?

    func append(withUID uid: Int64) -> Conversation
    func append() -> Conversation

    func clear()
    func clear(withUID uid: Int64)

    func startObserving()
    func stopObserving()
}

// MARK: -

extension ConversationManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Conversation {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }
}
