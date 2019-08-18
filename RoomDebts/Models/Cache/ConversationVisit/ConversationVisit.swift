//
//  ConversationVisit.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationVisit: AnyObject {

    // MARK: - Instance Properties

    var uid: Int64 { get set }

    var visitDate: Date? { get set }

    var userUID: Int64 { get set }
    var conversationUID: Int64 { get set }
}
