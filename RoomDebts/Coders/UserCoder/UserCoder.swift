//
//  UserCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserCoder: Coder {

    // MARK: - Instance Methods

    func decode(user: User, from json: [String: Any]) -> Bool
}
