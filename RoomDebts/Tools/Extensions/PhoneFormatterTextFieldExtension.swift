//
//  PhoneFormatterTextFieldExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import SwiftPhoneNumberFormatter

extension PhoneFormattedTextField {

    // MARK: - UITextField

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.placeholder = self.placeholder?.localized()
    }
}
