//
//  DefaultProductManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultProductManager<Object>: ProductManager, StorageContextObserver where Object: Product, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[Product]>()
    private(set) lazy var objectsAppendedEvent = Event<[Product]>()
    private(set) lazy var objectsUpdatedEvent = Event<[Product]>()
    private(set) lazy var objectsChangedEvent = Event<[Product]>()

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

    // MARK: - ProductManager

    func first(withUID uid: Int64) -> Product? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }

    func append(withUID uid: Int64) -> Product {
        let product = self.append()

        product.uid = uid

        return product
    }

    func append() -> Product {
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
        let products = self.filter(objects: objects)

        if !products.isEmpty {
            self.objectsRemovedEvent.emit(data: products)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let products = self.filter(objects: objects)

        if !products.isEmpty {
            self.objectsAppendedEvent.emit(data: products)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let products = self.filter(objects: objects)

        if !products.isEmpty {
            self.objectsUpdatedEvent.emit(data: products)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let products = self.filter(objects: objects)

        if !products.isEmpty {
            self.objectsChangedEvent.emit(data: products)
        }
    }
}
