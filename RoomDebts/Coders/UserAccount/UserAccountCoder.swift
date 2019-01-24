//
//  UserAccountCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserAccountCoder {
    
    // MARK: - Instance Properties
    
    func userAccountUID(from json: JSON) -> Int64?
    func userData(from json: JSON) -> JSON?
    
    func encode(firstName: String, lastName: String, phoneNumber: String) -> JSON
    
    func decode(userAccount: UserAccount, from json: JSON) -> Bool
}
