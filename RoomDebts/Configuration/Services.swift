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

    // MARK: -

    static let userAccountExtractor: UserAccountExtractor = DefaultUserAccountExtractor(userAccountCoder: Coders.userAccountCoder)
    static let accessExtactor: AccessExtractor = DefaultAccessExtractor(accessCoder: Coders.accessCoder)
    static let userExtractor: UserExtractor = DefaultUserExrtactor(userCoder: Coders.userCoder)
    static let conversationExtractor: ConversationExtractor = DefaultConversationExtractor(conversationCoder: Coders.conversationCoder,
                                                                                           userExtractor: Services.userExtractor)

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
