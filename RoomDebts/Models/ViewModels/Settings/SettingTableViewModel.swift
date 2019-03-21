//
//  SettingTableViewModel.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class SettingTableViewModel {

    // MARK: - Instance Properties

    var icon: UIImage?
    var title: String?

    // MARK: - Initializers

    init(icon: UIImage?, title: String?) {
        self.icon = icon
        self.title = title
    }
}
