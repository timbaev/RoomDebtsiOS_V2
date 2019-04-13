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
    var conversationManager: ConversationManager { get }
    var userManager: UserManager { get }
    var debtManager: DebtManager { get }
    var checkManager: CheckManager { get }

    var conversationListManager: ConversationListManager { get }
    var debtListManager: DebtListManager { get }

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
        KeychainManager.shared.clear()

        self.userAccountManager.clear()
        self.conversationManager.clear()
        self.userManager.clear()
        self.debtManager.clear()

        self.conversationListManager.clear()
        self.debtListManager.clear()

        self.save()
    }
}
