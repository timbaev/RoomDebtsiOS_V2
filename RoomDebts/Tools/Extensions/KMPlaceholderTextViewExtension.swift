//
//  KMPlaceholderTextViewExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import KMPlaceholderTextView

extension KMPlaceholderTextView {

    // MARK: - UITextView

    open override func awakeFromNib() {
        super.awakeFromNib()

        self.placeholder = self.placeholder.localized()
    }
}
