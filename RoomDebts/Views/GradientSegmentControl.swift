//
//  GradientSegmentControl.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 05/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class GradientSegmentControl: UISegmentedControl {

    // MARK: - Instance Properties

    override var selectedSegmentIndex: Int {
        didSet {
            self.updateGradientBackground()
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    // MARK: - Instance Methods

    private func initialize() {
        let gradient = CAGradientLayer()

        gradient.frame = self.frame
        gradient.colors = [Colors.Border.first.cgColor, Colors.Border.second.cgColor]

        let shape = CAShapeLayer()

        shape.lineWidth = 1
        shape.cornerRadius = 10
        shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.strokeColor = Colors.black.cgColor
        shape.fillColor = Colors.clear.cgColor

        gradient.mask = shape

        self.layer.addSublayer(gradient)
    }

    private func updateGradientBackground() {
        let sortedViews = self.subviews.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })

        sortedViews.enumerated().forEach { index, view in
            if index == self.selectedSegmentIndex {
                view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "PrimaryButtonBakcground.pdf"))
            } else {
                view.backgroundColor = Colors.clear
            }
        }
    }
}
