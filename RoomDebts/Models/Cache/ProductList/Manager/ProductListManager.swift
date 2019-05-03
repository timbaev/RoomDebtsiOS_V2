//
//  ProductListManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ProductListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[ProductList]> { get }
    var objectsAppendedEvent: Event<[ProductList]> { get }
    var objectsUpdatedEvent: Event<[ProductList]> { get }
    var objectsChangedEvent: Event<[ProductList]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: ProductListType) -> ProductList
    func firstOrNew() -> ProductList

    func lastOrNew(withListType listType: ProductListType) -> ProductList
    func lastOrNew() -> ProductList

    func first(withListType listType: ProductListType) -> ProductList?
    func first() -> ProductList?

    func last(withListType listType: ProductListType) -> ProductList?
    func last() -> ProductList?

    func fetch(withListType listType: ProductListType) -> [ProductList]
    func fetch() -> [ProductList]

    func count(withListType listType: ProductListType) -> Int
    func count() -> Int

    func clear(withListType listType: ProductListType)
    func clear()

    func remove(productList: ProductList)

    func append(withListType listType: ProductListType) -> ProductList
    func append() -> ProductList

    func startObserving()
    func stopObserving()
}

// MARK: -

extension ProductListManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withListType listType: ProductListType) -> ProductList {
        return self.first(withListType: listType) ?? self.append(withListType: listType)
    }

    func firstOrNew() -> ProductList {
        return self.first() ?? self.append()
    }

    func lastOrNew(withListType listType: ProductListType) -> ProductList {
        return self.last(withListType: listType) ?? self.append(withListType: listType)
    }

    func lastOrNew() -> ProductList {
        return self.last() ?? self.append()
    }
}
