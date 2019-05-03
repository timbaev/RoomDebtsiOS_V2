//
//  DefaultProductListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultProductListManager<Object>: ProductListManager, StorageContextObserver where Object: ProductList, Object: StorageObject {

    // MARK: - Instance Properties

    private lazy var sortDescriptors: [NSSortDescriptor] = {
        return [NSSortDescriptor(key: "listRawType", ascending: true)]
    }()

    // MARK: -

    unowned let context: CacheContext

    private(set) lazy var objectsRemovedEvent = Event<[ProductList]>()
    private(set) lazy var objectsAppendedEvent = Event<[ProductList]>()
    private(set) lazy var objectsUpdatedEvent = Event<[ProductList]>()
    private(set) lazy var objectsChangedEvent = Event<[ProductList]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    private func createPredicate(withListType listType: ProductListType) -> NSPredicate {
        var predicates = [NSPredicate(format: "listRawType == %d", listType.rawValue)]

        switch listType {
        case .check(let checkUID):
            predicates.append(NSPredicate(format: "checkUID == %d", checkUID))

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

    // MARK: - ProductListManager

    func first(withListType listType: ProductListType) -> ProductList? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func first() -> ProductList? {
        return self.storageManager.first(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func last(withListType listType: ProductListType) -> ProductList? {
        return self.storageManager.last(Object.self,
                                        sortDescriptors: self.sortDescriptors,
                                        predicate: self.createPredicate(withListType: listType))
    }

    func last() -> ProductList? {
        return self.storageManager.last(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func fetch(withListType listType: ProductListType) -> [ProductList] {
        return self.storageManager.fetch(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func fetch() -> [ProductList] {
        return self.storageManager.fetch(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func count(withListType listType: ProductListType) -> Int {
        return self.storageManager.count(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withListType: listType))
    }

    func count() -> Int {
        return self.storageManager.count(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func clear(withListType listType: ProductListType) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withListType: listType))
    }

    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }

    func remove(productList: ProductList) {
        if let productList = productList as? Object {
            self.storageManager.remove(object: productList)
        }
    }

    func append(withListType listType: ProductListType) -> ProductList {
        let productList = self.append()

        productList.listType = listType

        return productList
    }

    func append() -> ProductList {
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
        let productLists = self.filter(objects: objects)

        if !productLists.isEmpty {
            self.objectsRemovedEvent.emit(data: productLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let productLists = self.filter(objects: objects)

        if !productLists.isEmpty {
            self.objectsAppendedEvent.emit(data: productLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let productLists = self.filter(objects: objects)

        if !productLists.isEmpty {
            self.objectsUpdatedEvent.emit(data: productLists)
        }
    }

    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let productLists = self.filter(objects: objects)

        if !productLists.isEmpty {
            self.objectsChangedEvent.emit(data: productLists)
        }
    }
}
