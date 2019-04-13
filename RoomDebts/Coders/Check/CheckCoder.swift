//
//  CheckCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckCoder: Coder {

    // MARK: - Instance Methods

    func encode(form: CreateCheckForm) -> JSON?
    func decode(check: Check, from json: JSON) -> Bool
}
