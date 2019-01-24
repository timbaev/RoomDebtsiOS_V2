//
//  UserAccount.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserAccount: AnyObject {
    
    // MARK: - Instance Properties
    
    var uid: Int64 { get set }
    
    var firstName: String? { get set }
    var lastName: String? { get set }
    
    var phoneNumber: String? { get set }
    
}
