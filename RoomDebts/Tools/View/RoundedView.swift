//
//  RoundedView.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {

    // MARK: - Instance Properties

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = (self.cornerRadius > 0.0)
        }
    }
}
