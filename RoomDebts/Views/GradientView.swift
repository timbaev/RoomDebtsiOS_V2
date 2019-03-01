//
//  GradientView.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    // MARK: - Instance Properties

    @IBInspectable var firstColor = UIColor.clear {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var secondColor = UIColor.clear {
        didSet {
            self.applyState()
        }
    }

    // MARK: -

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Instance Methods

    private func applyState() {
        let layer = self.layer as! CAGradientLayer

        layer.colors = [self.firstColor, self.secondColor].map { $0.cgColor }
    }
}
