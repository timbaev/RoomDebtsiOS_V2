//
//  CacheManagerFactory.swift
//  Wager
//
//  Created by Oleg Gorelov on 30/09/2018.
//  Copyright © 2018 Influx. All rights reserved.
//

import Foundation

protocol CacheManagerFactory {
    
    // MARK: - Instance Methods
    
    func createUserAccountsManager(with context: CacheContext) -> UserAccountsManager
}
