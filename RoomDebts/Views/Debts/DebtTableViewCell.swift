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
    @IBOutlet private weak var requestLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var debtorLabel: UILabel!
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
            return !self.requestView.isHidden
        }

        set {
            self.requestView.isHidden = !newValue
        }
    }

    var isButtonsHidden: Bool {
        get {
            return self.acceptButton.isHidden && self.declineButton.isHidden
        }

        set {
            self.acceptButton.isHidden = newValue
            self.declineButton.isHidden = newValue
        }
    }

    var request: String? {
        get {
            return self.requestLabel.text
        }

        set {
            self.requestLabel.text = newValue
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

    var priceTextColor: UIColor {
        get {
            return self.priceLabel.textColor
        }

        set {
            self.priceLabel.textColor = newValue
        }
    }

    var debtor: String? {
        get {
            return self.debtorLabel.text
        }

        set {
            self.debtorLabel.text = newValue
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
