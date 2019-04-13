//
//  EncodableExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension Encodable {

    // MARK: - Instance Properties

    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
