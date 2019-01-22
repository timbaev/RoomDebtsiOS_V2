//
//  Result.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum Result<T> {
    
    // MARK: - Enumeration Cases
    
    case success
    case failure(T)
}
