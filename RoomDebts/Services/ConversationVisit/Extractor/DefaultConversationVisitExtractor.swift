//
//  DefaultConversationVisitExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

struct DefaultConversationVisitExtractor: ConversationVisitExtractor {

    // MARK: - Instance Properties

    let cacheProvider: CacheProvider

    let conversationVisitCoder: ConversationVisitCoder

    // MARK: - Instance Methods

    func extractConversationVisit(from json: JSON, cacheContext: CacheContext) throws -> ConversationVisit {
        guard let conversationVisitUID = self.conversationVisitCoder.uid(from: json) else {
            throw WebError(code: .badResponse)
        }

        let conversationVisit = cacheContext.conversationVisitManager.firstOrNew(withUID: conversationVisitUID)

        guard self.conversationVisitCoder.decode(conversationVisit: conversationVisit, from: json) else {
            throw WebError(code: .badResponse)
        }

        return conversationVisit
    }

    // MARK: - ConversationVisitExtractor

    func extractConversationVisit(from json: JSON) -> Promise<ConversationVisit> {
        return Promise(resolver: { seal in
            firstly {
                self.cacheProvider.captureModel()
            }.done { cacheSession in
                let backgroundContext = cacheSession.model.viewContext.createPrivateQueueChildContext()

                backgroundContext.perform(block: {
                    do {
                        let conversationVisitUID = try self.extractConversationVisit(from: json, cacheContext: backgroundContext).uid

                        backgroundContext.save()

                        cacheSession.model.viewContext.performAndWait(block: {
                            cacheSession.model.viewContext.save()

                            seal.fulfill(cacheSession.model.viewContext.conversationVisitManager.first(withUID: conversationVisitUID)!)
                        })
                    } catch {
                        DispatchQueue.main.async(execute: {
                            seal.reject(error)
                        })
                    }
                })
            }
        })
    }
}
