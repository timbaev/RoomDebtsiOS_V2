//
//  ParameterEncoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoder {
    
    // MARK: - Instance Methods
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
