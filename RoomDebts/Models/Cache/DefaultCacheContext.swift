//
//  DefaultCacheContext.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 30/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

final class DefaultCacheContext: CacheContext {

    // MARK: - Instance Properties

    let storageContext: StorageContext

    private(set) weak var model: CacheModel!
    private(set) weak var parent: CacheContext?

    // MARK: - CacheContext

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

    private(set) lazy var checkManager: CheckManager = { [unowned self] in
        return self.model.managerFactory.createCheckManager(with: self)
    }()

    private(set) lazy var productManager: ProductManager = { [unowned self] in
        return self.model.managerFactory.createProductManager(with: self)
    }()

    // MARK: -

    private(set) lazy var conversationListManager: ConversationListManager = { [unowned self] in
        return self.model.managerFactory.createConversationListManager(with: self)
    }()

    private(set) lazy var debtListManager: DebtListManager = { [unowned self] in
        return self.model.managerFactory.createDebtListManager(with: self)
    }()

    private(set) lazy var checkListManager: CheckListManager = { [unowned self] in
        return self.model.managerFactory.createCheckListManager(with: self)
    }()

    private(set) lazy var productListManager: ProductListManager = { [unowned self] in
        return self.model.managerFactory.createProductListManager(with: self)
    }()

    private(set) lazy var userListManager: UserListManager = { [unowned self] in
        return self.model.managerFactory.createUserListManager(with: self)
    }()

    // MARK: -

    var type: CacheContextType {
        return self.storageContext.type
    }

    // MARK: - Initializers

    required init(storageContext: StorageContext, model: CacheModel, parent: CacheContext?) {
        self.storageContext = storageContext

        self.model = model
        self.parent = parent
    }

    // MARK: - Instance Methods

    private func createChildContext<Context: DefaultCacheContext>(storageContext: StorageContext) -> Context {
        return Context(storageContext: storageContext, model: self.model, parent: self)
    }

    // MARK: -

    func createMainQueueChildContext() -> Self {
        return self.createChildContext(storageContext: self.storageContext.createMainQueueChildContext())
    }

    func createPrivateQueueChildContext() -> Self {
        return self.createChildContext(storageContext: self.storageContext.createPrivateQueueChildContext())
    }

    func performAndWait(block: @escaping () -> Void) {
        self.storageContext.performAndWait(block: block)
    }

    func perform(block: @escaping () -> Void) {
        self.storageContext.perform(block: block)
    }

    func rollback() {
        self.storageContext.rollback()
    }

    func save() {
        self.storageContext.save()
    }
}
