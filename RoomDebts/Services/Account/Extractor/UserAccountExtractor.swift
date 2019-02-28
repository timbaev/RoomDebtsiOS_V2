//
//  UserAccountExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserAccountExtractor {
    
    @discardableResult
    func extractUserAccount(from json: JSON, context: CacheContext) throws -> UserAccount
}
