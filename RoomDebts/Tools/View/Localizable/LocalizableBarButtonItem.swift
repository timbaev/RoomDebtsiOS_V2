//
//  LocalizableBarButtonItem.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/07/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LocalizableBarButtonItem: UIBarButtonItem {

    // MARK: - UIBarButtonItem

    override func awakeFromNib() {
        super.awakeFromNib()

        self.title = self.title?.localized()
    }
}
