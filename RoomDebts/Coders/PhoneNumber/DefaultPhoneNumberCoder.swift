//
//  DefaultPhoneNumberCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 25/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultPhoneNumberCoder: PhoneNumberCoder {
    
    // MARK: - Nested Types
    
    fileprivate enum JSONKeys {
        
        // MARK: - Type Properties
        
        static let phoneNumber = "phoneNumber"
    }
    
    // MARK: - Instance Methods
    
    func encode(phoneNumber: String) -> JSON {
        return [JSONKeys.phoneNumber: phoneNumber]
    }
}
