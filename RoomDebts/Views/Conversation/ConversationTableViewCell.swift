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
    @IBOutlet private weak var rejectStatusLabel: UILabel!
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

// MARK: - ConfigurableCell

extension ConversationTableViewCell: ConfigurableCell {

    // MARK: - Instance Methods

    func configure(data viewModel: ConversationTableViewModel) {
        self.avatarImageView.image = viewModel.avatar
        self.opponentNameLabel.text = viewModel.opponentName
        self.statusLabel.text = viewModel.status
        self.rejectStatusLabel.text = viewModel.rejectStatus
        self.priceLabel.text = viewModel.price
        self.priceLabel.textColor = viewModel.priceTextColor
        self.moreButton.isHidden = viewModel.isMoreButtonHidden
        self.visitedView.isHidden = viewModel.isVisited
        self.acceptButton.isHidden = !viewModel.isShowActions
        self.declineButton.isHidden = !viewModel.isShowActions
    }
}
