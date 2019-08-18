//
//  ConversationVisitManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationVisitManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[ConversationVisit]> { get }
    var objectsAppendedEvent: Event<[ConversationVisit]> { get }
    var objectsUpdatedEvent: Event<[ConversationVisit]> { get }
    var objectsChangedEvent: Event<[ConversationVisit]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> ConversationVisit

    func first(withUID uid: Int64) -> ConversationVisit?

    func append(withUID uid: Int64) -> ConversationVisit
    func append() -> ConversationVisit

    func clear()
    func clear(withUID uid: Int64)

    func startObserving()
    func stopObserving()
}

// MARK: -

extension ConversationVisitManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> ConversationVisit {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }
}
