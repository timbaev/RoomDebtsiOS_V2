//
//  ArrayExtension.swift
//  Tools
//
//  Created by Timur Shafigullin on 15/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {

    // MARK: - Instance Methods

    func unique() -> [Element] {
        return Array(Set(self))
    }

    func uniqueOrdered() -> [Element] {
        var uniqueValues: [Element] = []

        self.forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        
        return uniqueValues
    }
}
