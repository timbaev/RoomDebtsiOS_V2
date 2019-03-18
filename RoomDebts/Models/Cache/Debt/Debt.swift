//
//  Debt.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol Debt: AnyObject {

    // MARK: - Instance Properties

    var uid: Int64 { get set }

    var price: Double { get set }
    var date: Date? { get set }
    var debtDescription: String? { get set }
    var isRejected: Bool { get set }

    var creator: User? { get set }
    var debtorUID: Int64 { get set }
    var status: DebtStatus? { get set }
}
