//
//  MockCacheManagerFactory.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockCacheManagerFactory: CacheManagerFactory {

    // MARK: - Instance Methods

    func createUserAccountsManager(with context: CacheContext) -> UserAccountsManager {
        return MockUserAccountManager(context: context)
    }

    func createConversationManager(with context: CacheContext) -> ConversationManager {
        return MockConversationManager(context: context)
    }

    func createUserManager(with context: CacheContext) -> UserManager {
        return MockUserManager(context: context)
    }

    func createDebtManager(with context: CacheContext) -> DebtManager {
        return MockDebtManager(context: context)
    }

    // MARK: - 

    func createConversationListManager(with context: CacheContext) -> ConversationListManager {
        return MockConversationListManager(context: context)
    }

    func createDebtListManager(with context: CacheContext) -> DebtListManager {
        return MockDebtListManager(context: context)
    }
}
