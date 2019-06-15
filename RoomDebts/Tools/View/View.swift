//
//  View.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

@IBDesignable class View: UIView {

    // MARK: - Instance Properties

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = (self.cornerRadius > 0.0)
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }
}
