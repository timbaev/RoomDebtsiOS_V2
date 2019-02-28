//
//  UserManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager { get }

    var context: CacheContext { get }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> User

    func first(withUID uid: Int64) -> User?

    func append(withUID uid: Int64) -> User
    func append() -> User

    func clear()
}

// MARK: -

extension UserManager {

    // MARK: - Instance Properties

    var storageManager: StorageManager {
        return self.context.storageContext.manager
    }

    // MARK: - Instance Methods

    func firstOrNew(withUID uid: Int64) -> User {
        return self.first(withUID: uid) ?? self.append(withUID: uid)
    }
}
