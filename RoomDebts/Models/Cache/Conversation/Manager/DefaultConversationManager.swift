//
//  DefaultConversationManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultConversationManager<Object>: ConversationManager, StorageContextObserver where Object: Conversation, Object: StorageObject {

    // MARK: - Instance Properties

    fileprivate lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]

    // MARK: -

    unowned let context: CacheContext

    fileprivate(set) lazy var objectsRemovedEvent = Event<[Conversation]>()
    fileprivate(set) lazy var objectsAppendedEvent = Event<[Conversation]>()
    fileprivate(set) lazy var objectsUpdatedEvent = Event<[Conversation]>()
    fileprivate(set) lazy var objectsChangedEvent = Event<[Conversation]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    fileprivate func createPredicate(withUID uid: Int64) -> NSPredicate {
        return NSPredicate(format: "uid == %d", uid)
    }

    fileprivate func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }

    // MARK: - ConversationManager

    func first(withUID uid: Int64) -> Conversation? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }

    func append(withUID uid: Int64) -> Conversation {
        let conversation = self.append()

        conversation.uid = uid

        return conversation
    }

    func append() -> Conversation {
        return (self.storageManager.append() as Object?)!
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    // MARK: - StorageContextObserver

    func storageContext(_ storageContext: StorageContext, didRemoveObjects objects: [StorageObject]) {
        let conversations = self.filter(objects: objects)

        if !conversations.isEmpty {
            self.objectsRemovedEvent.emit(data: conversations)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let conversations = self.filter(objects: objects)

        if !conversations.isEmpty {
            self.objectsAppendedEvent.emit(data: conversations)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let conversations = self.filter(objects: objects)

        if !conversations.isEmpty {
            self.objectsUpdatedEvent.emit(data: conversations)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let conversations = self.filter(objects: objects)

        if !conversations.isEmpty {
            self.objectsChangedEvent.emit(data: conversations)
        }
    }
}
