//
//  DefaultUserAccountCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultUserAccountCoder: UserAccountCoder {
    
    // MARK: - Nested Types
    
    fileprivate enum JSONKeys {
        
        // MARK: - Type Properties
        
        static let id = "id"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let phoneNumber = "phoneNumber"
        static let isConfirmed = "isConfirmed"
        static let imageURL = "imageURL"
        
        static let userData = "userData"
    }
    
    // MARK: - Instance Methods
    
    func userAccountUID(from json: JSON) -> Int64? {
        return JSONKeys.id <~~ json
    }
    
    func userData(from json: JSON) -> JSON? {
        return JSONKeys.userData <~~ json
    }
    
    func encode(firstName: String, lastName: String, phoneNumber: String) -> JSON {
        return [
            JSONKeys.firstName: firstName,
            JSONKeys.lastName: lastName,
            JSONKeys.phoneNumber: phoneNumber
        ]
    }
    
    func decode(userAccount: UserAccount, from json: JSON) -> Bool {
        guard let id: Int64 = JSONKeys.id <~~ json else {
            return false
        }
        
        guard let firstName: String = JSONKeys.firstName <~~ json else {
            return false
        }
        
        guard let lastName: String = JSONKeys.lastName <~~ json else {
            return false
        }
        
        guard let phoneNumber: String = JSONKeys.phoneNumber <~~ json else {
            return false
        }
        
        let imageURL: URL? = JSONKeys.imageURL <~~ json
        
        userAccount.uid = id
        userAccount.firstName = firstName
        userAccount.lastName = lastName
        userAccount.phoneNumber = phoneNumber
        userAccount.avatarURL = imageURL
        
        return true
    }
}
