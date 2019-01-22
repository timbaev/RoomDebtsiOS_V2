//
//  DefaultUserAccountManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DefaultUserAccountsManager<Object>: UserAccountsManager, StorageContextObserver where Object: UserAccount, Object: StorageObject {
    
    // MARK: - Instance Properties
    
    fileprivate lazy var sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]
    
    // MARK: -
    
    let context: CacheContext
    
    fileprivate(set) lazy var objectsRemovedEvent = Event<[UserAccount]>()
    fileprivate(set) lazy var objectsAppendedEvent = Event<[UserAccount]>()
    fileprivate(set) lazy var objectsUpdatedEvent = Event<[UserAccount]>()
    fileprivate(set) lazy var objectsChangedEvent = Event<[UserAccount]>()
    
    // MARK: - Initializers
    
    init(context: CacheContext) {
        self.context = context
    }
    
    // MARK: - Instance Methods
    
    fileprivate func createPredicate(withUID uid: Int64) -> NSPredicate {
        return NSPredicate(format: "uid == %d", uid)
    }
    
    fileprivate func filter(objects: [StorageObject]) -> [Object] {
        return objects.compactMap({ object in
            return object as? Object
        })
    }
    
    // MARK: - UserAccountManager
    
    func first(withUID uid: Int64) -> UserAccount? {
        return self.storageManager.first(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }
    
    func first() -> UserAccount? {
        return self.storageManager.first(Object.self, sortDescriptors: self.sortDescriptors)
    }
    
    func last(withUID uid: Int64) -> UserAccount? {
        return self.storageManager.last(Object.self,
                                        sortDescriptors: self.sortDescriptors,
                                        predicate: self.createPredicate(withUID: uid))
    }
    
    func last() -> UserAccount? {
        return self.storageManager.last(Object.self, sortDescriptors: self.sortDescriptors)
    }
    
    func fetch(withUID uid: Int64) -> [UserAccount] {
        return self.storageManager.fetch(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }
    
    func fetch() -> [UserAccount] {
        return self.storageManager.fetch(Object.self, sortDescriptors: self.sortDescriptors)
    }
    
    func count(withUID uid: Int64) -> Int {
        return self.storageManager.count(Object.self,
                                         sortDescriptors: self.sortDescriptors,
                                         predicate: self.createPredicate(withUID: uid))
    }
    
    func count() -> Int {
        return self.storageManager.count(Object.self, sortDescriptors: self.sortDescriptors)
    }
    
    func clear(withUID uid: Int64) {
        self.storageManager.clear(Object.self,
                                  sortDescriptors: self.sortDescriptors,
                                  predicate: self.createPredicate(withUID: uid))
    }
    
    func clear() {
        self.storageManager.clear(Object.self, sortDescriptors: self.sortDescriptors)
    }
    
    func remove(userAccount: UserAccount) {
        if let userAccount = userAccount as? Object {
            self.storageManager.remove(object: userAccount)
        }
    }
    
    func append(withUID uid: Int64) -> UserAccount {
        let userAccount = self.append()
        
        userAccount.uid = uid
        
        return userAccount
    }
    
    func append() -> UserAccount {
        return (self.storageManager.append() as Object?)!
    }
    
    func startObserving() {
        self.storageManager.context.addObserver(self)
    }
    
    func stopObserving() {
        self.storageManager.context.removeObserver(self)
    }
    
    // MARK: - StorageContextObserver
    
    func storageContext(_ storageContext: StorageContext, didRemoveObjects objects: [StorageObject]) {
        let userAccounts = self.filter(objects: objects)
        
        if !userAccounts.isEmpty {
            self.objectsRemovedEvent.emit(data: userAccounts)
        }
    }
    
    func storageContext(_ storageContext: StorageContext, didAppendObjects objects: [StorageObject]) {
        let userAccounts = self.filter(objects: objects)
        
        if !userAccounts.isEmpty {
            self.objectsAppendedEvent.emit(data: userAccounts)
        }
    }
    
    func storageContext(_ storageContext: StorageContext, didUpdateObjects objects: [StorageObject]) {
        let userAccounts = self.filter(objects: objects)
        
        if !userAccounts.isEmpty {
            self.objectsUpdatedEvent.emit(data: userAccounts)
        }
    }
    
    func storageContext(_ storageContext: StorageContext, didChangeObjects objects: [StorageObject]) {
        let userAccounts = self.filter(objects: objects)
        
        if !userAccounts.isEmpty {
            self.objectsChangedEvent.emit(data: userAccounts)
        }
    }
}
