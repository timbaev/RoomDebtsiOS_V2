//
//  CheckUserCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckUserCoder: Coder {

    // MARK: - Instance Methods

    func decode(checkUser: CheckUser, from json: JSON) -> Bool

    func userJSON(from json: JSON) -> JSON?
}
