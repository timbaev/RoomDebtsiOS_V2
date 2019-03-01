//
//  DefaultConfirmCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultConfirmCoder: ConfirmCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let phoneNumber = "phoneNumber"
        static let code = "code"
    }

    // MARK: - Instance Methods

    func encode(phoneNumber: String, code: String) -> JSON {
        return [
            JSONKeys.phoneNumber: phoneNumber,
            JSONKeys.code: code
        ]
    }
}
