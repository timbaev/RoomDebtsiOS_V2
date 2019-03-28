//
//  MockUserAccountManager.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockUserAccountManager: UserAccountsManager {

    // MARK: - Instance Properties

    var context: CacheContext

    var objectsRemovedEvent = Event<[UserAccount]>()
    var objectsAppendedEvent = Event<[UserAccount]>()
    var objectsUpdatedEvent = Event<[UserAccount]>()
    var objectsChangedEvent = Event<[UserAccount]>()

    // MARK: - Initializers

    init(context: CacheContext) {
        self.context = context
    }

    // MARK: - Instance Methods

    func first(withUID uid: Int64) -> UserAccount? {
        return nil
    }

    func first() -> UserAccount? {
        return nil
    }

    func last(withUID uid: Int64) -> UserAccount? {
        return nil
    }

    func last() -> UserAccount? {
        return nil
    }

    func fetch(withUID uid: Int64) -> [UserAccount] {
        return []
    }

    func fetch() -> [UserAccount] {
        return []
    }

    func count(withUID uid: Int64) -> Int {
        return 0
    }

    func count() -> Int {
        return 0
    }

    func clear(withUID uid: Int64) {

    }

    func clear() {

    }

    func remove(userAccount: UserAccount) {

    }

    func append(withUID uid: Int64) -> UserAccount {
        return MockUserAccount()
    }

    func append() -> UserAccount {
        return MockUserAccount()
    }

    func startObserving() {

    }

    func stopObserving() {

    }
}
