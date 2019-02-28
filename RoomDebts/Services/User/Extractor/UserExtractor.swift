//
//  UserExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserExtractor {

    // MARK: - Instance Methods

    func extractSearchUsers(from json: [[String: Any]]) throws -> [User]
    func extractUser(from json: [String: Any], cacheContext: CacheContext) throws -> User
}
