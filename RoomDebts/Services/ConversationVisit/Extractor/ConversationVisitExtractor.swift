//
//  ConversationVisitExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

protocol ConversationVisitExtractor {

    // MARK: - Instance Methods

    func extractConversationVisit(from json: JSON) -> Promise<ConversationVisit>
}
