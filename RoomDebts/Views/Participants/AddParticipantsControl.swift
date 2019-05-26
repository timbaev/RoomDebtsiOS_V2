//
//  AddParticipantsControl.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 25/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class AddParticipantsControl: UIControl {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let transitionOptions: UIView.AnimationOptions = [.transitionCrossDissolve,
                                                                 .allowAnimatedContent,
                                                                 .allowUserInteraction]
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: -

    override var isHighlighted: Bool {
        didSet {
            self.applyState()
        }
    }

    // MARK: - Instance Methods

    private func applyState() {
        if self.isHighlighted {
            UIView.transition(with: self, duration: 0.05, options: Constants.transitionOptions, animations: {
                self.titleLabel.textColor = Colors.addParticipantsButton.withAlphaComponent(0.2)
                self.iconImageView.alpha = 0.2
            })
        } else {
            UIView.transition(with: self, duration: 0.25, options: Constants.transitionOptions, animations: {
                self.titleLabel.textColor = Colors.addParticipantsButton
                self.iconImageView.alpha = 1.0
            })
        }
    }
}
