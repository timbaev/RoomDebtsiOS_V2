//
//  AccessExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol AccessExtractor {

    // MARK: - Instance Methods

    @discardableResult
    func extract(from json: JSON) throws -> Access
}
