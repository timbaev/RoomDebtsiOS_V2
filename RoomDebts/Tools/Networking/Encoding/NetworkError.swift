//
//  NetworkError.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    
    // MARK: - Enumeration Cases
    
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
    
    // MARK: - Instance Properties
    
    var localized: String {
        return self.rawValue.localized()
    }
}
