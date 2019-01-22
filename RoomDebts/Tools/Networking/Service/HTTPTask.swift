//
//  HTTPTask.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    
    // MARK: - Enumeration Cases
    
    case request
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestParametersAndHeader(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeader: HTTPHeaders?)
}
