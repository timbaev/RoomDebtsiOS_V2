//
//  LocalizableNavigationItem.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 30/07/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LocalizableNavigationItem: UINavigationItem {

    // MARK: - UINavigationItem

    override func awakeFromNib() {
        super.awakeFromNib()

        self.title = self.title?.localized()
    }
}
