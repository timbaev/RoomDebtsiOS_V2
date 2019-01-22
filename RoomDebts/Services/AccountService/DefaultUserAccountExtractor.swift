//
//  DefaultUserAccountExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultUserAccountExtractor: UserAccountExtractor {
    
    // MARK: - Instance Properties
    
    let userAccountCoder: UserAccountCoder
    
    // MARK: - Instance Methods
    
    func extractUserAccount(from json: JSON, context: CacheContext) throws -> UserAccount {
        guard let userAccountUID = self.userAccountCoder.userAccountUID(from: json) else {
            throw WebError(code: .badResponse)
        }
        
        let userAccount = context.userAccountManager.firstOrNew(withUID: userAccountUID)
        
        guard self.userAccountCoder.decode(userAccount: userAccount, from: json) else {
            throw WebError(code: .badResponse)
        }
        
        return userAccount
    }
}
