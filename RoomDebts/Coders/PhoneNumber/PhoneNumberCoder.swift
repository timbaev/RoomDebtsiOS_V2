//
//  PhoneNumberCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 25/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol PhoneNumberCoder {
    
    // MARK: - Instance Properties
    
    func encode(phoneNumber: String) -> JSON
}
