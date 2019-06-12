//
//  Services.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum Services {

    // MARK: - Type Properties

    static let accountService: AccountService = DefaultAccountService(userAccountExtractor: Services.userAccountExtractor,
                                                                      accessExtractor: Services.accessExtactor)

    static let userService: UserService = DefaultUserService(userExtractor: Services.userExtractor)

    static let conversationService: ConversationService = DefaultConversationService(conversationExtractor: Services.conversationExtractor)
    static let debtService: DebtService = DefaultDebtService(debtExtractor: Services.debtExtractor)

    static let checkService: CheckService = DefaultCheckService(checkExtractor: Services.checkExtractor,
                                                                productExtractor: Services.productExtractor,
                                                                checkUserExtractor: Services.checkUserExtractor)

    static let productService: ProductService = DefaultProductService(productExtractor: Services.productExtractor)

    // MARK: -

    static let userAccountExtractor: UserAccountExtractor = DefaultUserAccountExtractor(userAccountCoder: Coders.userAccountCoder)
    static let accessExtactor: AccessExtractor = DefaultAccessExtractor(accessCoder: Coders.accessCoder)
    static let userExtractor: UserExtractor = DefaultUserExrtactor(userCoder: Coders.userCoder)

    static let conversationExtractor: ConversationExtractor = DefaultConversationExtractor(conversationCoder: Coders.conversationCoder,
                                                                                           userCoder: Coders.userCoder,
                                                                                           userExtractor: Services.userExtractor)

    static let debtExtractor: DebtExtractor = DefaultDebtExtractor(debtCoder: Coders.debtCoder,
                                                                   userCoder: Coders.userCoder,
                                                                   userExtractor: Services.userExtractor)

    static let checkExtractor: CheckExtractor = DefaultCheckExtractor(checkCoder: Coders.checkCoder,
                                                                      userCoder: Coders.userCoder,
                                                                      userExtractor: Services.userExtractor)

    static let productExtractor: ProductExtractor = DefaultProductExtractor(productCoder: Coders.productCoder,
                                                                            userExtractor: Services.userExtractor)

    static let checkUserExtractor: CheckUserExtractor = DefaultCheckUserExtractor(userExtractor: Services.userExtractor,
                                                                                  checkUserCoder: Coders.checkUserCoder)

    // MARK: -

    static var cacheProvider: CacheProvider = DefaultCacheProvider<DefaultCacheSession>(model: Models.cacheModel)

    // MARK: -

    static var cacheViewContext: CacheContext {
        return Services.cacheProvider.model.viewContext
    }

    static var userAccount: UserAccount? {
        return Services.cacheProvider.model.viewContext.userAccountManager.first()
    }
}
