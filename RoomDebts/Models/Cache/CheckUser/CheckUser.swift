//
//  CheckUser.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckUser: AnyObject {

    // MARK: - Instance Properties

    var uid: Int64 { get set }

    var status: CheckUserStatus? { get set }
    var comment: String? { get set }
    var total: Double { get set }
    var reviewDate: Date? { get set }

    var user: User? { get set }
}
