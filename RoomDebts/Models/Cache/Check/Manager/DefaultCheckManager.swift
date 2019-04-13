//
//  DefaultCheckManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultCheckManager<Object>: CheckManager, StorageContextObserver where Object: Check, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[Check]>()
    private(set) lazy var objectsAppendedEvent = Event<[Check]>()
    private(set) lazy var objectsUpdatedEvent = Event<[Check]>()
    private(set) lazy var objectsChangedEvent = Event<[Check]>()

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

    // MARK: - CheckManager

    func first(withUID uid: Int64) -> Check? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }

    func append(withUID uid: Int64) -> Check {
        let check = self.append()

        check.uid = uid

        return check
    }

    func append() -> Check {
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
        let checks = self.filter(objects: objects)

        if !checks.isEmpty {
            self.objectsRemovedEvent.emit(data: checks)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let checks = self.filter(objects: objects)

        if !checks.isEmpty {
            self.objectsAppendedEvent.emit(data: checks)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let checks = self.filter(objects: objects)

        if !checks.isEmpty {
            self.objectsUpdatedEvent.emit(data: checks)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let checks = self.filter(objects: objects)

        if !checks.isEmpty {
            self.objectsChangedEvent.emit(data: checks)
        }
    }
}
