//
//  Conversation.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol Conversation: AnyObject {

    // MARK: - Instance Properties

    var uid: Int64 { get set }

    var debtorUID: Int64 { get set }
    var price: Double { get set }
    var newDebtCount: Int64 { get set }

    var status: ConversationStatus? { get set }
    var rejectStatus: ConversationStatus? { get set }

    var creator: User? { get set }
    var opponent: User? { get set }
}
