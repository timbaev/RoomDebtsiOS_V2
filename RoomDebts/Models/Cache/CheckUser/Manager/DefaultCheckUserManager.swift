//
//  DefaultCheckUserManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultCheckUserManager<Object>: CheckUserManager, StorageContextObserver where Object: CheckUser, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[CheckUser]>()
    private(set) lazy var objectsAppendedEvent = Event<[CheckUser]>()
    private(set) lazy var objectsUpdatedEvent = Event<[CheckUser]>()
    private(set) lazy var objectsChangedEvent = Event<[CheckUser]>()

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

    // MARK: - CheckUserManager

    func first(withUID uid: Int64) -> CheckUser? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }

    func append(withUID uid: Int64) -> CheckUser {
        let checkUser = self.append()

        checkUser.uid = uid

        return checkUser
    }

    func append() -> CheckUser {
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
        let checkUsers = self.filter(objects: objects)

        if !checkUsers.isEmpty {
            self.objectsRemovedEvent.emit(data: checkUsers)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let checkUsers = self.filter(objects: objects)

        if !checkUsers.isEmpty {
            self.objectsAppendedEvent.emit(data: checkUsers)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let checkUsers = self.filter(objects: objects)

        if !checkUsers.isEmpty {
            self.objectsUpdatedEvent.emit(data: checkUsers)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let checkUsers = self.filter(objects: objects)

        if !checkUsers.isEmpty {
            self.objectsChangedEvent.emit(data: checkUsers)
        }
    }
}
