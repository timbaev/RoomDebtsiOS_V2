//
//  Models.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum Models {
    
    // MARK: - Type Properties
    
    static let cacheStorageModel: StorageModel = CoreDataStorageModel(identifier: "RoomDebts")
    
    static let cacheContextFactory: CacheContextFactory = DefaultCacheContextFactory()
    static let cacheManagerFactory: CacheManagerFactory = DefaultCacheManagerFactory()
    
    static let cacheModel: CacheModel = DefaultCacheModel(storageModel: Models.cacheStorageModel,
                                                          contextFactory: Models.cacheContextFactory,
                                                          managerFactory: Models.cacheManagerFactory)
}
