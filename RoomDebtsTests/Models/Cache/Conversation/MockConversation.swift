//
//  MockConversation.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockConversation: Conversation {

    // MARK: - Instance Properties

    var uid: Int64 = 0
    var debtorUID: Int64 = 0
    var price: Double = 0.0

    var status: ConversationStatus?
    var rejectStatus: ConversationStatus?
    var creator: User?
    var opponent: User?
}
