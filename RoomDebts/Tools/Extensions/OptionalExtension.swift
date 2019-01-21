//
//  OptionalExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    // MARK: - Instance Properties
    
    var isNotEmpty: Bool {
        return !(self?.isEmpty ?? true)
    }
    
}
