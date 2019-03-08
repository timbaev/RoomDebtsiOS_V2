//
//  GradientSegmentControl.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 05/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class GradientSegmentControl: UISegmentedControl {

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

    @objc private func onSegmentControlValueChanged(_ sender: UISegmentedControl) {
        self.updateGradientBackground()
    }

    // MARK: -

    private func updateGradientBackground() {
        let sortedViews = self.subviews.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })

        sortedViews.enumerated().forEach { index, view in
            if index == self.selectedSegmentIndex {
                view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "PrimaryGradientBackground.pdf"))
                view.tintColor = Colors.clear
            } else {
                view.backgroundColor = Colors.clear
                view.tintColor = Colors.clear
            }
        }
    }

    // MARK: -

    private func initialize() {
        self.addTarget(self, action: #selector(self.onSegmentControlValueChanged(_:)), for: .valueChanged)

        self.setTitleTextAttributes([.font: Fonts.regular(ofSize: 17),
                                     .foregroundColor: Colors.white], for: .normal)

        self.setTitleTextAttributes([.font: Fonts.regular(ofSize: 17),
                                     .foregroundColor: Colors.white], for: .selected)

        let cornerRadius = self.bounds.height / 2

        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius

        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.cornerRadius = cornerRadius
        gradient.colors = [Colors.Border.first.cgColor, Colors.Border.second.cgColor]

        let shape = CAShapeLayer()

        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shape.strokeColor = Colors.black.cgColor
        shape.fillColor = Colors.clear.cgColor

        gradient.mask = shape

        self.layer.addSublayer(gradient)

        self.updateGradientBackground()
    }
}
