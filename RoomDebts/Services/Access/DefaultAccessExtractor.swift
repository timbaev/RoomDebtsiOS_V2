//
//  DefaultAccessExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultAccessExtractor: AccessExtractor {

    // MARK: - Instance Properties

    let accessCoder: AccessCoder

    // MARK: - Instance Methods

    func extract(from json: JSON) throws -> Access {
        guard let access = self.accessCoder.decode(from: json) else {
            throw WebError(code: .badResponse)
        }

        KeychainManager.shared.access = access

        return access
    }
}
