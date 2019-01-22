//
//  DefaultUserAccountCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultUserAccountCoder: UserAccountCoder {
    
    // MARK: - Nested Types
    
    fileprivate enum JSONKeys {
        
        // MARK: - Type Properties
        
        static let id = "id"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let phoneNumber = "phoneNumber"
        static let isConfirmed = "isConfirmed"
    }
    
    // MARK: - Instance Methods
    
    func userAccountUID(from json: JSON) -> Int64? {
        return json[JSONKeys.id] as? Int64
    }
    
    func encode(firstName: String, lastName: String, phoneNumber: String) -> JSON {
        return [
            JSONKeys.firstName: firstName,
            JSONKeys.lastName: lastName,
            JSONKeys.phoneNumber: phoneNumber
        ]
    }
    
    func decode(userAccount: UserAccount, from json: JSON) -> Bool {
        userAccount.uid = json[JSONKeys.id] as! Int64
        userAccount.firstName = json[JSONKeys.firstName] as? String
        userAccount.lastName = json[JSONKeys.lastName] as? String
        userAccount.phoneNumber = json[JSONKeys.phoneNumber] as? String
        userAccount.isConfirmed = json[JSONKeys.isConfirmed] as! Bool
        
        return true
    }
}
