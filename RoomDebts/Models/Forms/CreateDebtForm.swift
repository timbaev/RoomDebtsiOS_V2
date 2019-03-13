//
//  CreateDebtForm.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct CreateDebtForm {

    // MARK: - Instance Properties

    let price: Double
    let date: Date
    let description: String?
    let debtorUID: Int64
    let conversationUID: Int64
}
