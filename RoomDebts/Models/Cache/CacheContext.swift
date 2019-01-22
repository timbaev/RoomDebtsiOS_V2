//
//  CacheContext.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CacheContext: AnyObject {
    
    // MARK: - Instance Properties
    
    var storageContext: StorageContext { get }
    
    var model: CacheModel! { get }
    var parent: CacheContext? { get }
    
    var userAccountManager: UserAccountsManager { get }
    
    var type: CacheContextType { get }
    
    // MARK: - Instance Methods
    
    func createMainQueueChildContext() -> Self
    func createPrivateQueueChildContext() -> Self
    
    func performAndWait(block: @escaping () -> Void)
    func perform(block: @escaping () -> Void)
    
    func rollback()
    func save()
    
    func clear()
}

// MARK: -

extension CacheContext {
    
    // MARK: - Instance Methods
    
    func clear() {
        self.userAccountManager.clear()
        
        self.save()
    }
}
