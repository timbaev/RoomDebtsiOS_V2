//
//  CheckExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckExtractor {

    // MARK: - Instance Methods

    func extractCheck(from json: JSON, cacheContext: CacheContext) throws -> Check
}
