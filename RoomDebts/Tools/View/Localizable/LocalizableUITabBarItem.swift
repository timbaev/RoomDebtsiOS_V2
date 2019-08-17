//
//  LocalizableUITabBarItem.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LocalizableTabBarItem: UITabBarItem {

    // MARK: - UITabBarItem

    override func awakeFromNib() {
        super.awakeFromNib()

        self.title = self.title?.localized()
    }
}
