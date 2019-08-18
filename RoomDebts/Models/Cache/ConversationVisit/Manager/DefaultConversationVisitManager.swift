//
//  DefaultConversationVisitManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultConversationVisitManager<Object>: ConversationVisitManager, StorageContextObserver where Object: ConversationVisit, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[ConversationVisit]>()
    private(set) lazy var objectsAppendedEvent = Event<[ConversationVisit]>()
    private(set) lazy var objectsUpdatedEvent = Event<[ConversationVisit]>()
    private(set) lazy var objectsChangedEvent = Event<[ConversationVisit]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    private func createPredicate(withUID uid: Int64) -> NSPredicate {
        return NSPredicate(format: "uid == %d", uid)
    }

    private func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }

    // MARK: - ConversationVisitManager

    func first(withUID uid: Int64) -> ConversationVisit? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }

    func append(withUID uid: Int64) -> ConversationVisit {
        let conversationVisit = self.append()

        conversationVisit.uid = uid

        return conversationVisit
    }

    func append() -> ConversationVisit {
        return (self.storageManager.append() as Object?)!
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func clear(withUID uid: Int64) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withUID: uid))
    }

    func startObserving() {
        self.storageManager.context.addObserver(self)
    }

    func stopObserving() {
        self.storageManager.context.removeObserver(self)
    }

    // MARK: - StorageContextObserver

    func storageContext(_ storageContext: StorageContext, didRemoveObjects objects: [StorageObject]) {
        let conversationVisits = self.filter(objects: objects)

        if !conversationVisits.isEmpty {
            self.objectsRemovedEvent.emit(data: conversationVisits)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let conversationVisits = self.filter(objects: objects)

        if !conversationVisits.isEmpty {
            self.objectsAppendedEvent.emit(data: conversationVisits)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let conversationVisits = self.filter(objects: objects)

        if !conversationVisits.isEmpty {
            self.objectsUpdatedEvent.emit(data: conversationVisits)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let conversationVisits = self.filter(objects: objects)

        if !conversationVisits.isEmpty {
            self.objectsChangedEvent.emit(data: conversationVisits)
        }
    }
}
