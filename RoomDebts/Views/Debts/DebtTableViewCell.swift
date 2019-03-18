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

    @IBOutlet private weak var toolbarStackView: UIStackView!
    @IBOutlet private weak var repayButton: UIButton!

    // MARK: -

    var onAcceptButtonClick: (() -> Void)?
    var onDeclineButtonClick: (() -> Void)?

    var onEditButtonClick: (() -> Void)?
    var onRepayButtonClick: (() -> Void)?
    var onDeleteButtonClick: (() -> Void)?

    // MARK: - Instance Methods

    @IBAction private func onAcceptButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onAcceptButtonClick?()
    }

    @IBAction private func onDeclineButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onDeclineButtonClick?()
    }

    @IBAction private func onEditButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onEditButtonClick?()
    }

    @IBAction private func onRepayButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onRepayButtonClick?()
    }

    @IBAction private func onDeleteButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.onDeleteButtonClick?()
    }
}

// MARK: - ConfigurableCell

extension DebtTableViewCell: ConfigurableCell {

    // MARK: - Instance Methods

    func configure(data viewModel: DebtTableViewModel) {
        self.requestView.isHidden = !viewModel.hasRequest
        self.acceptButton.isHidden = viewModel.isButtonsHidden
        self.declineButton.isHidden = viewModel.isButtonsHidden
        self.requestLabel.text = viewModel.request
        self.priceLabel.text = viewModel.price
        self.priceLabel.textColor = viewModel.priceTextColor
        self.debtorLabel.text = viewModel.debtor
        self.dateLabel.text = viewModel.date

        if let description = viewModel.debtDescription {
            self.descriptionLabel.text = description
            self.descriptionStackView.isHidden = false
        } else {
            self.descriptionStackView.isHidden = true
        }

        self.creatorLabel.text = viewModel.creator
        self.toolbarStackView.isHidden = viewModel.isToolbarHidden
        self.repayButton.isHidden = viewModel.isRepayButtonHidden
    }
}
