//
//  Coder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

fileprivate enum JSONKeys {

    // MARK: - Type Properties

    static let id = "id"
}

protocol Coder {

    // MARK: - Instance Methods

    func uid(from json: [String: Any]) -> Int64?
}

extension Coder {

    // MARK: - Instance Methods

    func uid(from json: [String: Any]) -> Int64? {
        return JSONKeys.id <~~ json
    }
}
