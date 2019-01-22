//
//  CacheProvider.swift
//  Wager
//
//  Created by Oleg Gorelov on 08/09/2018.
//  Copyright © 2018 Influx. All rights reserved.
//

import Foundation

protocol CacheProvider {
    
    // MARK: - Instance Properties
    
    var isModelCaptured: Bool { get }
    
    var model: CacheModel { get }
}
