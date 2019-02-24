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

    func extractUsers(from json: [[String: Any]]) throws -> [User]
}
