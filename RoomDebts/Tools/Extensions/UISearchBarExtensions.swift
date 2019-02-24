//
//  UISearchBarExtensions.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

extension UISearchBar {

    // MARK: - Instance Properties

    var textField: UITextField? {
        return self.subviews.map { $0.subviews.first(where: { $0 is UITextInputTraits }) as? UITextField }
            .compactMap { $0 }
            .first
    }
}
