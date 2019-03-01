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
