//
//  LocalizableButton.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/07/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LocalizableButton: UIButton {

    // MARK: - UIButton

    override func awakeFromNib() {
        super.awakeFromNib()

        self.setTitle(self.title(for: .normal)?.localized(), for: .normal)
    }
}
