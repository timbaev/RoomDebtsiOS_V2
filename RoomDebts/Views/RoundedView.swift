//
//  RoundedView.swift
//  UULA
//
//  Created by Timur Shafigullin on 13/02/2019.
//  Copyright © 2019 AZ Solutions. All rights reserved.
//

import UIKit

@IBDesignable public class RoundedView: UIView {

    // MARK: - Instance Properties

    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = (self.cornerRadius > 0.0)
        }
    }
}
