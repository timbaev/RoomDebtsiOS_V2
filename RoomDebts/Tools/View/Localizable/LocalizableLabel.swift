//
//  LocalizableLabel.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/07/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LocalizableLabel: UILabel {

    // MARK: - UILabel

    override func awakeFromNib() {
        super.awakeFromNib()

        self.text = self.text?.localized()
    }
}
