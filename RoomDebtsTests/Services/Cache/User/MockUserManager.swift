//
//  MockUserManager.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockUserManager: UserManager {

    // MARK: - Instance Properties

    var context: CacheContext

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    func first(withUID uid: Int64) -> User? {
        return nil
    }

    func append(withUID uid: Int64) -> User {
        return MockUser()
    }

    func append() -> User {
        return MockUser()
    }

    func clear() {

    }
}
