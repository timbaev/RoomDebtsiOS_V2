//
//  DefaultConversationVisitService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

struct DefaultConversationVisitService: ConversationVisitService {

    // MARK: - Instance Properties

    private let router = AuthRouter<ConversationVisitAPI>()

    // MARK: -

    let conversationVisitExtractor: ConversationVisitExtractor

    // MARK: - Instance Methods

    func update(for conversationUID: Int64) -> Promise<ConversationVisit> {
        return Promise(resolver: { seal in
            self.router.jsonObject(.update(conversationUID: conversationUID), success: { response in
                firstly {
                    self.conversationVisitExtractor.extractConversationVisit(from: response.content)
                }.done { conversationVisit in
                    seal.fulfill(conversationVisit)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }
}
