//
//  Access.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 23/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct Access {
    
    // MARK: - Instance Properties
    
    var accessToken: String
    var refreshToken: String
    var expiredAt: Date
}
