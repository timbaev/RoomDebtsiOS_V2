//
//  DebtCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol DebtCoder: Coder {

    // MARK: - Instance Methods

    func encode(createForm form: CreateDebtForm) -> JSON
    func encode(conversationUID: Int64) -> JSON

    func decode(debt: Debt, from json: JSON) -> Bool
}
