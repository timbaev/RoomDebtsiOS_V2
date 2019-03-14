//
//  DebtTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 14/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class DebtTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var requestView: GradientView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var acceptButton: RoundedButton!
    @IBOutlet private weak var declineButton: RoundedButton!

    // MARK: -

    var onAcceptButtonClick: (() -> Void)?
    var onDeclineButtonClick: (() -> Void)?

    // MARK: -

    var hasRequest: Bool {
        get {
            return !(self.requestView.isHidden && self.acceptButton.isHidden && self.declineButton.isHidden)
        }

        set {
            self.requestView.isHidden = !newValue
            self.acceptButton.isHidden = !newValue
            self.declineButton.isHidden = !newValue
        }
    }

    var price: String? {
        get {
            return self.priceLabel.text
        }

        set {
            self.priceLabel.text = newValue
        }
    }

    var date: String? {
        get {
            return self.dateLabel.text
        }

        set {
            self.dateLabel.text = newValue
        }
    }

    var debtDescription: String? {
        get {
            return self.descriptionLabel.text
        }

        set {
            if let newValue = newValue {
                self.descriptionLabel.text = newValue
                self.descriptionStackView.isHidden = false
            } else {
                self.descriptionStackView.isHidden = true
            }
        }
    }

    var creator: String? {
        get {
            return self.creatorLabel.text
        }

        set {
            self.creatorLabel.text = newValue
        }
    }

    // MARK: - Instance Methods

    @IBAction private func onAcceptButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onAcceptButtonClick?()
    }

    @IBAction private func onDeclineButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onDeclineButtonClick?()
    }
}
