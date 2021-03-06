//
//  CacheModel.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 08/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CacheModel: AnyObject {

    // MARK: - Instance Properties

    var storageModel: StorageModel { get }

    var contextFactory: CacheContextFactory { get }
    var managerFactory: CacheManagerFactory { get }

    var viewContext: CacheContext { get }
}
