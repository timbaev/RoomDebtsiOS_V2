//
//  ConversationVisitService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

protocol ConversationVisitService {

    // MARK: - Instance Methods

    func update(for conversationUID: Int64) -> Promise<ConversationVisit>
}
