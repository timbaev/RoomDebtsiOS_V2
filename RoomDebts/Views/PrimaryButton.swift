//
//  PrimaryButton.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class PrimaryButton: LocalizableButton {

    // MARK: - Instance Properties

    override var isEnabled: Bool {
        didSet {
            self.applyState()
        }
    }

    // MARK: - Instance Methods

    private func applyState() {
        if self.isEnabled {
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.setTitleColor(Colors.white, for: .normal)
                self.setBackgroundImage(#imageLiteral(resourceName: "PrimaryButtonBakcground.pdf"), for: .normal)
            })
        } else {
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.setTitleColor(Colors.white.withAlphaComponent(0.6), for: .normal)
                self.setBackgroundImage(#imageLiteral(resourceName: "PrimaryButtonDisabledBackground.pdf"), for: .normal)
            })
        }
    }

    // MARK: - UIButton

    override func awakeFromNib() {
        super.awakeFromNib()

        self.applyState()
    }
}
