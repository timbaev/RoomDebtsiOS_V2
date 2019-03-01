//
//  CoreDataStorageContext.swift
//  Tools
//
//  Created by Almaz Ibragimov on 25.02.2018.
//  Copyright © 2018 Flatstack. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStorageContext<Manager: CoreDataStorageManager>: StorageContext {
    
    // MARK: - Instance Properties
    
    public let managedObjectContext: NSManagedObjectContext
    
    // MARK: - StorageContext
    
    public private(set) var observers: [StorageContextObserver] = []
    
    public private(set) weak var model: StorageModel!
    public private(set) weak var parent: StorageContext?
    
    public private(set) lazy var manager: StorageManager = { [unowned self] in
        return Manager(managedObjectContext: self.managedObjectContext, context: self)
    }()
    
    public var type: StorageContextType {
        return self.managedObjectContext.storageContextType
    }
    
    // MARK: - Initializers
    
    public required init(managedObjectContext: NSManagedObjectContext, model: StorageModel, parent: StorageContext?) {
        self.managedObjectContext = managedObjectContext
        
        self.model = model
        self.parent = parent
    }
    
    // MARK: - Instance Methods
    
    @objc private func onManagedObjectContextObjectsDidChange(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        var changedObjects: [StorageObject] = []

        if let objects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, !objects.isEmpty {
            let removedObjects = Array(objects)

            for observer in self.observers {
                observer.storageContext(self, didRemoveObjects: removedObjects)
            }

            changedObjects.append(contentsOf: removedObjects)
        }

        if let objects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, !objects.isEmpty {
            let appendedObjects = Array(objects)

            for observer in self.observers {
                observer.storageContext(self, didAppendObjects: appendedObjects)
            }

            changedObjects.append(contentsOf: appendedObjects)
        }

        if let objects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !objects.isEmpty {
            let updatedObjects = Array(objects)

            for observer in self.observers {
                observer.storageContext(self, didUpdateObjects: updatedObjects)
            }
            
            changedObjects.append(contentsOf: updatedObjects)
        }

        if !changedObjects.isEmpty {
            for observer in self.observers {
                observer.storageContext(self, didChangeObjects: changedObjects)
            }
        }
    }
    
    private func createChildContext(concurrencyType: NSManagedObjectContextConcurrencyType) -> CoreDataStorageContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        
        managedObjectContext.parent = self.managedObjectContext
        managedObjectContext.mergePolicy = NSMergePolicy(merge: .errorMergePolicyType)
        
        return CoreDataStorageContext(managedObjectContext: managedObjectContext, model: self.model, parent: self)
    }
    
    // MARK: - StorageContext
    
    public func addObserver(_ observer: StorageContextObserver) {
        if self.observers.isEmpty {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.onManagedObjectContextObjectsDidChange(_ :)),
                                                   name: .NSManagedObjectContextObjectsDidChange,
                                                   object: self.managedObjectContext)
        }
        
        if !self.observers.contains(where: { $0 === observer }) {
            self.observers.append(observer)
        }
    }
    
    public func removeObserver(_ observer: StorageContextObserver) {
        if let index = self.observers.index(where: { $0 === observer }) {
            self.observers.remove(at: index)
        }
        
        if self.observers.isEmpty {
            NotificationCenter.default.removeObserver(self,
                                                      name: .NSManagedObjectContextObjectsDidChange,
                                                      object: self.managedObjectContext)
        }
    }
    
    public func createMainQueueChildContext() -> StorageContext {
        return self.createChildContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    public func createPrivateQueueChildContext() -> StorageContext {
        return self.createChildContext(concurrencyType: .privateQueueConcurrencyType)
    }
    
    public func performAndWait(block: @escaping () -> Void) {
        self.managedObjectContext.performAndWait(block)
    }
    
    public func perform(block: @escaping () -> Void) {
        self.managedObjectContext.perform(block)
    }
    
    public func rollback() {
        self.managedObjectContext.rollback()
    }
    
    public func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Can not save CoreData context")
            }
        }
    }
}
