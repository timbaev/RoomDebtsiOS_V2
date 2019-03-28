//
//  MockCacheContext.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockCacheContext: CacheContext {

    // MARK: - Instance Properties

    private(set) var clearCalled = false

    // MARK: -

    var storageContext: StorageContext
    var model: CacheModel!
    var parent: CacheContext?

    // MARK: -

    private(set) lazy var userAccountManager: UserAccountsManager = { [unowned self] in
        return self.model.managerFactory.createUserAccountsManager(with: self)
    }()

    private(set) lazy var conversationManager: ConversationManager = { [unowned self] in
        return self.model.managerFactory.createConversationManager(with: self)
    }()

    private(set) lazy var userManager: UserManager = { [unowned self] in
        return self.model.managerFactory.createUserManager(with: self)
    }()

    private(set) lazy var debtManager: DebtManager = { [unowned self] in
        return self.model.managerFactory.createDebtManager(with: self)
    }()

    // MARK: -

    private(set) lazy var conversationListManager: ConversationListManager = { [unowned self] in
        return self.model.managerFactory.createConversationListManager(with: self)
    }()

    private(set) lazy var debtListManager: DebtListManager = { [unowned self] in
        return self.model.managerFactory.createDebtListManager(with: self)
    }()

    // MARK: -

    var type: CacheContextType = .mainQueue

    // MARK: - Initializers

    required init(storageContext: StorageContext, model: CacheModel, parent: CacheContext?) {
        self.storageContext = storageContext

        self.model = model
        self.parent = parent
    }

    // MARK: - Instance Methods

    func createMainQueueChildContext() -> Self {
        return self
    }

    func createPrivateQueueChildContext() -> Self {
        return self
    }

    func performAndWait(block: @escaping () -> Void) {

    }

    func perform(block: @escaping () -> Void) {

    }

    func rollback() {

    }

    func save() {

    }

    func clear() {
        self.clearCalled = true
    }
}
