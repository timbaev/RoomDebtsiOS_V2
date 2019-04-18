//
//  DefaultCheckListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 15/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultCheckListManager<Object>: CheckListManager, StorageContextObserver where Object: CheckList, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors: [NSSortDescriptor] = {
        return [NSSortDescriptor(key: "listRawType", ascending: true)]
    }()

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[CheckList]>()
    private(set) lazy var objectsAppendedEvent = Event<[CheckList]>()
    private(set) lazy var objectsUpdatedEvent = Event<[CheckList]>()
    private(set) lazy var objectsChangedEvent = Event<[CheckList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    private func createPredicate(withListType listType: CheckListType) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "listRawType == %d", listType.rawValue)])
    }

    private func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }

    // MARK: - CheckListManager

    func first(withListType listType: CheckListType) -> CheckList? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func first() -> CheckList? {
        return self.storageManager.first(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func last(withListType listType: CheckListType) -> CheckList? {
        return self.storageManager.last(Object.self,
                                        sortDescriptors: self.sortDescriptors,
                                        predicate: self.createPredicate(withListType: listType))
    }

    func last() -> CheckList? {
        return self.storageManager.last(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func fetch(withListType listType: CheckListType) -> [CheckList] {
        return self.storageManager.fetch(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func fetch() -> [CheckList] {
        return self.storageManager.fetch(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func count(withListType listType: CheckListType) -> Int {
        return self.storageManager.count(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func count() -> Int {
        return self.storageManager.count(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func clear(withListType listType: CheckListType) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withListType: listType))
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func remove(checkList: CheckList) {
        if let checkList = checkList as? Object {
            self.storageManager.remove(object: checkList)
        }
    }

    func append(withListType listType: CheckListType) -> CheckList {
        let checkList = self.append()

        checkList.listType = listType

        return checkList
    }

    func append() -> CheckList {
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
        let checkList = self.filter(objects: objects)

        if !checkList.isEmpty {
            self.objectsRemovedEvent.emit(data: checkList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let checkList = self.filter(objects: objects)

        if !checkList.isEmpty {
            self.objectsAppendedEvent.emit(data: checkList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let checkList = self.filter(objects: objects)

        if !checkList.isEmpty {
            self.objectsUpdatedEvent.emit(data: checkList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let checkList = self.filter(objects: objects)

        if !checkList.isEmpty {
            self.objectsChangedEvent.emit(data: checkList)
        }
    }
}
