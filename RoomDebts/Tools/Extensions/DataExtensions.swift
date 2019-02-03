//
//  DataExtensions.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension Data {
    
    // MARK: - Instance Methods
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
