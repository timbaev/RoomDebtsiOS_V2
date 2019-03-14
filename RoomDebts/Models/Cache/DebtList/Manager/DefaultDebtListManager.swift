//
//  DefaultDebtListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 14/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultDebtListManager<Object>: DebtListManager, StorageContextObserver where Object: DebtList, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors: [NSSortDescriptor] = {
        return [NSSortDescriptor(key: "listRawType", ascending: true)]
    }()

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[DebtList]>()
    private(set) lazy var objectsAppendedEvent = Event<[DebtList]>()
    private(set) lazy var objectsUpdatedEvent = Event<[DebtList]>()
    private(set) lazy var objectsChangedEvent = Event<[DebtList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    private func createPredicate(withListType listType: DebtListType) -> NSPredicate {
        var predicates = [NSPredicate(format: "listRawType == %d", listType.rawValue)]

        switch listType {
        case .conversation(let conversationUID):
            predicates.append(NSPredicate(format: "conversationUID == %d", conversationUID))

        case .unknown:
            break
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    private func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }

    // MARK: - DebtListManager

    func first(withListType listType: DebtListType) -> DebtList? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func first() -> DebtList? {
        return self.storageManager.first(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func last(withListType listType: DebtListType) -> DebtList? {
        return self.storageManager.last(Object.self,
                                        sortDescriptors: self.sortDescriptors,
                                        predicate: self.createPredicate(withListType: listType))
    }

    func last() -> DebtList? {
        return self.storageManager.last(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func fetch(withListType listType: DebtListType) -> [DebtList] {
        return self.storageManager.fetch(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func fetch() -> [DebtList] {
        return self.storageManager.fetch(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func count(withListType listType: DebtListType) -> Int {
        return self.storageManager.count(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func count() -> Int {
        return self.storageManager.count(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func clear(withListType listType: DebtListType) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withListType: listType))
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func remove(debtList: DebtList) {
        if let debtList = debtList as? Object {
            self.storageManager.remove(object: debtList)
        }
    }

    func append(withListType listType: DebtListType) -> DebtList {
        let debtList = self.append()

        debtList.listType = listType

        return debtList
    }

    func append() -> DebtList {
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
        let debtList = self.filter(objects: objects)

        if !debtList.isEmpty {
            self.objectsRemovedEvent.emit(data: debtList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let debtList = self.filter(objects: objects)

        if !debtList.isEmpty {
            self.objectsAppendedEvent.emit(data: debtList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let debtList = self.filter(objects: objects)

        if !debtList.isEmpty {
            self.objectsUpdatedEvent.emit(data: debtList)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let debtList = self.filter(objects: objects)

        if !debtList.isEmpty {
            self.objectsChangedEvent.emit(data: debtList)
        }
    }
}
