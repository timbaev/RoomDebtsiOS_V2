//
//  DefaultUserListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultUserListManager<Object>: UserListManager, StorageContextObserver where Object: UserList, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors: [NSSortDescriptor] = {
        return [NSSortDescriptor(key: "listRawType", ascending: true)]
    }()

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[UserList]>()
    private(set) lazy var objectsAppendedEvent = Event<[UserList]>()
    private(set) lazy var objectsUpdatedEvent = Event<[UserList]>()
    private(set) lazy var objectsChangedEvent = Event<[UserList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    private func createPredicate(withListType listType: UserListType) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "listRawType == %d", listType.rawValue)])
    }

    private func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }

    // MARK: - UserListManager

    func first(withListType listType: UserListType) -> UserList? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func first() -> UserList? {
        return self.storageManager.first(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func last(withListType listType: UserListType) -> UserList? {
        return self.storageManager.last(Object.self,
                                        sortDescriptors: self.sortDescriptors,
                                        predicate: self.createPredicate(withListType: listType))
    }

    func last() -> UserList? {
        return self.storageManager.last(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func fetch(withListType listType: UserListType) -> [UserList] {
        return self.storageManager.fetch(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func fetch() -> [UserList] {
        return self.storageManager.fetch(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func count(withListType listType: UserListType) -> Int {
        return self.storageManager.count(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func count() -> Int {
        return self.storageManager.count(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func clear(withListType listType: UserListType) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withListType: listType))
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func remove(userList: UserList) {
        if let userList = userList as? Object {
            self.storageManager.remove(object: userList)
        }
    }

    func append(withListType listType: UserListType) -> UserList {
        let userList = self.append()

        userList.listType = listType

        return userList
    }

    func append() -> UserList {
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
        let userLists = self.filter(objects: objects)

        if !userLists.isEmpty {
            self.objectsRemovedEvent.emit(data: userLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let userLists = self.filter(objects: objects)

        if !userLists.isEmpty {
            self.objectsAppendedEvent.emit(data: userLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let userLists = self.filter(objects: objects)

        if !userLists.isEmpty {
            self.objectsUpdatedEvent.emit(data: userLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let userLists = self.filter(objects: objects)

        if !userLists.isEmpty {
            self.objectsChangedEvent.emit(data: userLists)
        }
    }
}
