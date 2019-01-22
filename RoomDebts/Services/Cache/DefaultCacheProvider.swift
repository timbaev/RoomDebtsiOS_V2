//
//  DefaultCacheProvider.swift
//  Wager
//
//  Created by Oleg Gorelov on 08/09/2018.
//  Copyright © 2018 Influx. All rights reserved.
//

import Foundation

class DefaultCacheProvider<Session: CacheSession>: CacheProvider {
    
    // MARK: - Instance Properties
    
    fileprivate var captureResolvers: [(CacheSession) -> Void] = []
    
    // MARK: - CacheProvider
    
    fileprivate(set) var isModelCaptured = false
    
    let model: CacheModel
    
    // MARK: - Initializers
    
    init(model: CacheModel) {
        self.model = model
    }
    
    // MARK: - Instance Methods
    
    fileprivate func createSession() -> CacheSession {
        return Session(model: self.model, releaseHandler: { [weak self] in
            self?.resolveNextCapture()
        })
    }
    
    fileprivate func resolveNextCapture() {
        if !self.captureResolvers.isEmpty {
            self.isModelCaptured = true
            
            self.captureResolvers.removeFirst()(self.createSession())
        } else {
            self.isModelCaptured = false
        }
    }
}
