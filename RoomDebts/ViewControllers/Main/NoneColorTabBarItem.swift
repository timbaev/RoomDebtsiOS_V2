//
//  NoneColorTabBarItem.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class NoneColorTabBarItem: UITabBarItem {

    // MARK: - UITabBarItem

    override func awakeFromNib() {
        super.awakeFromNib()

        if let image = self.image {
            self.image = image.withRenderingMode(.alwaysOriginal)
        }

        if let selectedImage = self.selectedImage {
            self.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        }
    }
}
