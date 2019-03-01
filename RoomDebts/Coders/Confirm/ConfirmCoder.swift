//
//  ConfirmCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConfirmCoder {

    // MARK: - Instance Methods

    func encode(phoneNumber: String, code: String) -> JSON
}
