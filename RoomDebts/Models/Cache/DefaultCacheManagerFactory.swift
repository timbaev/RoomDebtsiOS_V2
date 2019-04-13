//
//  DefaultCacheManagerFactory.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 30/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultCacheManagerFactory: CacheManagerFactory {

    // MARK: - Instance Methods

    func createUserAccountsManager(with context: CacheContext) -> UserAccountsManager {
        return DefaultUserAccountsManager<DefaultUserAccount>(context: context)
    }

    func createConversationManager(with context: CacheContext) -> ConversationManager {
        return DefaultConversationManager<DefaultConversation>(context: context)
    }

    func createUserManager(with context: CacheContext) -> UserManager {
        return DefaultUserManager<DefaultUser>(context: context)
    }

    func createDebtManager(with context: CacheContext) -> DebtManager {
        return DefaultDebtManager<DefaultDebt>(context: context)
    }

    func createCheckManager(with context: CacheContext) -> CheckManager {
        return DefaultCheckManager<DefaultCheck>(context: context)
    }

    // MARK: -

    func createConversationListManager(with context: CacheContext) -> ConversationListManager {
        return DefaultConversationListManager<DefaultConversationList>(context: context)
    }

    func createDebtListManager(with context: CacheContext) -> DebtListManager {
        return DefaultDebtListManager<DefaultDebtList>(context: context)
    }
}
