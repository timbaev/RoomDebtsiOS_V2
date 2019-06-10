//
//  CheckUserExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckUserExtractor {

    // MARK: - Instance Methods

    func extractCheckUserList(from json: [JSON], withListType listType: CheckUserListType, cacheContext: CacheContext) throws -> CheckUserList
}
