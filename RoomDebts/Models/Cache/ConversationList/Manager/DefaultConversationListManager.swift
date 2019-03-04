//
//  DefaultConversationListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 01/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultConversationListManager<Object>: ConversationListManager, StorageContextObserver where Object: ConversationList, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors: [NSSortDescriptor] = {
        return [NSSortDescriptor(key: "listRawType", ascending: true)]
    }()

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[ConversationList]>()
    private(set) lazy var objectsAppendedEvent = Event<[ConversationList]>()
    private(set) lazy var objectsUpdatedEvent = Event<[ConversationList]>()
    private(set) lazy var objectsChangedEvent = Event<[ConversationList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    private func createPredicate(withListType listType: ConversationListType) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "listRawType == %d", listType.rawValue)])
    }

    private func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }

    // MARK: - ConversationListManager

    func first(withListType listType: ConversationListType) -> ConversationList? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func first() -> ConversationList? {
        return self.storageManager.first(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func last(withListType listType: ConversationListType) -> ConversationList? {
        return self.storageManager.last(Object.self,
                                        sortDescriptors: self.sortDescriptors,
                                        predicate: self.createPredicate(withListType: listType))
    }

    func last() -> ConversationList? {
        return self.storageManager.last(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func fetch(withListType listType: ConversationListType) -> [ConversationList] {
        return self.storageManager.fetch(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func fetch() -> [ConversationList] {
        return self.storageManager.fetch(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func count(withListType listType: ConversationListType) -> Int {
        return self.storageManager.count(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func count() -> Int {
        return self.storageManager.count(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func clear(withListType listType: ConversationListType) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withListType: listType))
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func remove(conversationList: ConversationList) {
        if let conversationList = conversationList as? Object {
            self.storageManager.remove(object: conversationList)
        }
    }

    func append(withListType listType: ConversationListType) -> ConversationList {
        let conversationList = self.append()

        conversationList.listType = listType

        return conversationList
    }

    func append() -> ConversationList {
        return (self.storageManager.append() as Object?)!
    }

    func startObserving() {
        self.storageManager.context.addObserver(self)
    }

    func stopObserving() {
        self.storageManager.context.removeObserver(self)
    }

    // MARK: - StorageContextObserver

    func storageContext(_ storageContext: StorageContext, didRemoveObjects objects: [StorageObject]) {
        let conversationList = self.filter(objects: objects)

        if !conversationList.isEmpty {
            self.objectsRemovedEvent.emit(data: conversationList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let conversationList = self.filter(objects: objects)

        if !conversationList.isEmpty {
            self.objectsAppendedEvent.emit(data: conversationList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let conversationList = self.filter(objects: objects)

        if !conversationList.isEmpty {
            self.objectsUpdatedEvent.emit(data: conversationList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let conversationList = self.filter(objects: objects)

        if !conversationList.isEmpty {
            self.objectsChangedEvent.emit(data: conversationList)
        }
    }
}
