//
//  DefaultCacheProvider.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 08/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

class DefaultCacheProvider<Session: CacheSession>: CacheProvider {

    // MARK: - Instance Properties

    private var captureResolvers: [(CacheSession) -> Void] = []

    // MARK: - CacheProvider

    private(set) var isModelCaptured = false

    let model: CacheModel

    // MARK: - Initializers

    init(model: CacheModel) {
        self.model = model
    }

    // MARK: - Instance Methods

    private func createSession() -> CacheSession {
        return Session(model: self.model, releaseHandler: { [weak self] in
            self?.resolveNextCapture()
        })
    }

    private func resolveNextCapture() {
        if !self.captureResolvers.isEmpty {
            self.isModelCaptured = true

            self.captureResolvers.removeFirst()(self.createSession())
        } else {
            self.isModelCaptured = false
        }
    }

    // MARK: - CacheProvider

    func captureModel() -> Guarantee<CacheSession> {
        return Guarantee(resolver: { completion in
            if self.isModelCaptured {
                self.captureResolvers.append(completion)
            } else {
                self.isModelCaptured = true

                completion(self.createSession())
            }
        })
    }
}
