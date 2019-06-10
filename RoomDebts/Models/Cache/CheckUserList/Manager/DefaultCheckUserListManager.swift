//
//  DefaultCheckUserListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultCheckUserListManager<Object>: CheckUserListManager, StorageContextObserver where Object: CheckUserList, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors: [NSSortDescriptor] = {
        return [NSSortDescriptor(key: "listRawType", ascending: true)]
    }()

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[CheckUserList]>()
    private(set) lazy var objectsAppendedEvent = Event<[CheckUserList]>()
    private(set) lazy var objectsUpdatedEvent = Event<[CheckUserList]>()
    private(set) lazy var objectsChangedEvent = Event<[CheckUserList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    private func createPredicate(withListType listType: CheckUserListType) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "listRawType == %d", listType.rawValue)])
    }

    private func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }

    // MARK: - CheckUserListManager

    func first(withListType listType: CheckUserListType) -> CheckUserList? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func first() -> CheckUserList? {
        return self.storageManager.first(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func last(withListType listType: CheckUserListType) -> CheckUserList? {
        return self.storageManager.last(Object.self,
                                        sortDescriptors: self.sortDescriptors,
                                        predicate: self.createPredicate(withListType: listType))
    }

    func last() -> CheckUserList? {
        return self.storageManager.last(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func fetch(withListType listType: CheckUserListType) -> [CheckUserList] {
        return self.storageManager.fetch(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func fetch() -> [CheckUserList] {
        return self.storageManager.fetch(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func count(withListType listType: CheckUserListType) -> Int {
        return self.storageManager.count(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func count() -> Int {
        return self.storageManager.count(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func clear(withListType listType: CheckUserListType) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withListType: listType))
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func remove(checkUserList: CheckUserList) {
        if let checkUserList = checkUserList as? Object {
            self.storageManager.remove(object: checkUserList)
        }
    }

    func append(withListType listType: CheckUserListType) -> CheckUserList {
        let checkUserList = self.append()

        checkUserList.listType = listType

        return checkUserList
    }

    func append() -> CheckUserList {
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
        let checkUserLists = self.filter(objects: objects)

        if !checkUserLists.isEmpty {
            self.objectsRemovedEvent.emit(data: checkUserLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let checkUserLists = self.filter(objects: objects)

        if !checkUserLists.isEmpty {
            self.objectsAppendedEvent.emit(data: checkUserLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let checkUserLists = self.filter(objects: objects)

        if !checkUserLists.isEmpty {
            self.objectsUpdatedEvent.emit(data: checkUserLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let checkUserLists = self.filter(objects: objects)

        if !checkUserLists.isEmpty {
            self.objectsChangedEvent.emit(data: checkUserLists)
        }
    }
}
