//
//  RoundedImageView.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    // MARK: - Instance Properties

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = (self.cornerRadius > 0.0)
        }
    }
}
