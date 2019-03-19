//
//  ConversationTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var opponentNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!

    @IBOutlet private weak var visitedView: GradientView!

    @IBOutlet private weak var acceptButton: RoundedButton!
    @IBOutlet private weak var declineButton: RoundedButton!

    // MARK: -

    var onAcceptButtonClick: (() -> Void)?
    var onDeclineButtonClick: (() -> Void)?
    var onMoreButtonClick: (() -> Void)?

    // MARK: -

    var avatar: UIImage? {
        get {
            return self.avatarImageView.image
        }

        set {
            self.avatarImageView.image = newValue
        }
    }

    var opponentName: String? {
        get {
            return self.opponentNameLabel.text
        }

        set {
            self.opponentNameLabel.text = newValue
        }
    }

    var status: String? {
        get {
            return self.statusLabel.text
        }

        set {
            self.statusLabel.text = newValue
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

    var isMoreButtonHidden: Bool {
        get {
            return self.moreButton.isHidden
        }

        set {
            self.moreButton.isHidden = newValue
        }
    }

    var isVisited: Bool {
        get {
            return self.visitedView.isHidden
        }

        set {
            self.visitedView.isHidden = newValue
        }
    }

    var isShowActions: Bool {
        get {
            return !(self.acceptButton.isHidden && self.declineButton.isHidden)
        }

        set {
            self.acceptButton.isHidden = !newValue
            self.declineButton.isHidden = !newValue
        }
    }

    // MARK: -

    var avatarImageViewTarget: UIImageView {
        return self.avatarImageView
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

    @IBAction private func onMoreButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onMoreButtonClick?()
    }
}
