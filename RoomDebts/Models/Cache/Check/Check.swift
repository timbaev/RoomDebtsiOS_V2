//
//  Check.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol Check: AnyObject {

    // MARK: - Instance Properties

    var uid: Int64 { get set }

    var date: Date? { get set }
    var store: String? { get set }
    var totalSum: Double { get set }
    var address: String? { get set }

    var status: CheckStatus? { get set }

    var imageURL: URL? { get set }

    var creator: User? { get set }
}
