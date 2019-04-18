//
//  CacheManagerFactory.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 30/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CacheManagerFactory {

    // MARK: - Instance Methods

    func createUserAccountsManager(with context: CacheContext) -> UserAccountsManager
    func createConversationManager(with context: CacheContext) -> ConversationManager
    func createUserManager(with context: CacheContext) -> UserManager
    func createDebtManager(with context: CacheContext) -> DebtManager
    func createCheckManager(with context: CacheContext) -> CheckManager

    func createConversationListManager(with context: CacheContext) -> ConversationListManager
    func createDebtListManager(with context: CacheContext) -> DebtListManager
    func createCheckListManager(with context: CacheContext) -> CheckListManager
}
