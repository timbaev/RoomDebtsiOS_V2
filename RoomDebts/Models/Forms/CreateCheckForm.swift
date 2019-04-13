//
//  CreateCheckForm.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 12/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct CreateCheckForm: Codable {

    // MARK: - Instance Properties

    let date: String
    let sum: Int
    let fiscalSign: Int
    let fd: Int
    let n: Int
    let fn: String
}
