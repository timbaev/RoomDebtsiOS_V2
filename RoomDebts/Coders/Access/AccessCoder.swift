//
//  AccessCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 23/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol AccessCoder {

    // MARK: - Instance Properties

    func decode(from json: JSON) -> Access?
}
