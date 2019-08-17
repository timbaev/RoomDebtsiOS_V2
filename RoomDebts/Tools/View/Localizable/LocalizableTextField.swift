//
//  LocalizableTextField.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LocalizableTextField: UITextField {

    // MARK: - UITextField

    override func awakeFromNib() {
        super.awakeFromNib()

        self.text = self.text?.localized()
        self.placeholder = self.placeholder?.localized()
    }
}

