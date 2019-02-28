//
//  Coders.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum Coders {
    
    // MARK: - Type Properties
    
    static let userAccountCoder: UserAccountCoder = DefaultUserAccountCoder()
    static let accessCoder: AccessCoder = DefaultAccessCoder()
    static let confirmCoder: ConfirmCoder = DefaultConfirmCoder()
    static let phoneNumberCoder: PhoneNumberCoder = DefaultPhoneNumberCoder()
    static let userCoder: UserCoder = DefaultUserCoder()
    static let conversationCoder: ConversationCoder = DefaultConversationCoder()
}
