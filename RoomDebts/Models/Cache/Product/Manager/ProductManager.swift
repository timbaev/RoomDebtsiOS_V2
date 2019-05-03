//
//  ProductManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ProductManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    var objectsRemovedEvent: Event<[Product]> { get }
    var objectsAppendedEvent: Event<[Product]> { get }
    var objectsUpdatedEvent: Event<[Product]> { get }
    var objectsChangedEvent: Event<[Product]> { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Product

    func first(withUID uid: Int64) -> Product?

    func append(withUID uid: Int64) -> Product
    func append() -> Product

    func clear()
    func clear(withUID uid: Int64)

    func startObserving()
    func stopObserving()
}

// MARK: -

extension ProductManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> Product {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }
}
