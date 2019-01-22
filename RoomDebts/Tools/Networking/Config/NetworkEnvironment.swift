//
//  NetworkEnvironment.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum NetworkEnvironment: String {
    
    // MARK: - Instance Properties
    
    case local = "http://localhost:8080"
    case staging = "staging-room-debts-api.com"
    case production = "room-debts-api.com"
}
