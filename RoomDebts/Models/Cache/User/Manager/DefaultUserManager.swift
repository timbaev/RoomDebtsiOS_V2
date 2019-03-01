//
//  DefaultUserManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultUserManager<Object>: UserManager, StorageContextObserver where Object: User, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[User]>()
    private(set) lazy var objectsAppendedEvent = Event<[User]>()
    private(set) lazy var objectsUpdatedEvent = Event<[User]>()
    private(set) lazy var objectsChangedEvent = Event<[User]>()

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

    // MARK: - UserManager

    func first(withUID uid: Int64) -> User? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }

    func append(withUID uid: Int64) -> User {
        let user = self.append()

        user.uid = uid

        return user
    }

    func append() -> User {
        return (self.storageManager.append() as Object?)!
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    // MARK: - StorageContextObserver

    func storageContext(_ storageContext: StorageContext, didRemoveObjects objects: [StorageObject]) {
        let users = self.filter(objects: objects)

        if !users.isEmpty {
            self.objectsRemovedEvent.emit(data: users)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let users = self.filter(objects: objects)

        if !users.isEmpty {
            self.objectsAppendedEvent.emit(data: users)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let users = self.filter(objects: objects)

        if !users.isEmpty {
            self.objectsUpdatedEvent.emit(data: users)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let users = self.filter(objects: objects)

        if !users.isEmpty {
            self.objectsChangedEvent.emit(data: users)
        }
    }
}
