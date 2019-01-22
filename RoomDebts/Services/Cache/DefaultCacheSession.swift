//
//  DefaultCacheSession.swift
//  Wager
//
//  Created by Oleg Gorelov on 08/09/2018.
//  Copyright © 2018 Influx. All rights reserved.
//

import Foundation

class DefaultCacheSession: CacheSession {
    
    // MARK: - Instance Properties
    
    let releaseHandler: () -> Void
    
    // MARK: - AccountModelSession
    
    fileprivate(set) var model: CacheModel
    
    // MARK: - Initializers
    
    required init(model: CacheModel, releaseHandler: @escaping (() -> Void)) {
        self.releaseHandler = releaseHandler
        
        self.model = model
    }
    
    deinit {
        self.releaseHandler()
    }
}
