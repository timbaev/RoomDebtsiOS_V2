//
//  DefaultDebtManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultDebtManager<Object>: DebtManager, StorageContextObserver where Object: Debt, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[Debt]>()
    private(set) lazy var objectsAppendedEvent = Event<[Debt]>()
    private(set) lazy var objectsUpdatedEvent = Event<[Debt]>()
    private(set) lazy var objectsChangedEvent = Event<[Debt]>()

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

    // MARK: - DebtManager

    func first(withUID uid: Int64) -> Debt? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }

    func append(withUID uid: Int64) -> Debt {
        let debt = self.append()

        debt.uid = uid

        return debt
    }

    func append() -> Debt {
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
        let debts = self.filter(objects: objects)

        if !debts.isEmpty {
            self.objectsRemovedEvent.emit(data: debts)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let debts = self.filter(objects: objects)

        if !debts.isEmpty {
            self.objectsAppendedEvent.emit(data: debts)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let debts = self.filter(objects: objects)

        if !debts.isEmpty {
            self.objectsUpdatedEvent.emit(data: debts)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let debts = self.filter(objects: objects)

        if !debts.isEmpty {
            self.objectsChangedEvent.emit(data: debts)
        }
    }
}
