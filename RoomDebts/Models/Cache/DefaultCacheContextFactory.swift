//
//  DefaultCacheContextFactory.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 30/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultCacheContextFactory: CacheContextFactory {

    // MARK: - Instance Methods

    func createCacheContext(storageContext: StorageContext, model: CacheModel, parent: CacheContext?) -> CacheContext {
        return DefaultCacheContext(storageContext: storageContext, model: model, parent: parent)
    }
}
