//
//  CheckTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var avatarImageView: RoundedImageView!
    @IBOutlet private weak var storeLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var rejectStatusLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
}

// MARK: - ConfigurableCell

extension CheckTableViewCell: ConfigurableCell {

    // MARK: - Instance Properties

    var targetImageView: UIImageView? {
        return self.avatarImageView
    }

    // MARK: - Instance Methods

    func configure(data viewModel: CheckViewModel) {
        self.storeLabel.text = viewModel.store
        self.statusLabel.textColor = viewModel.statusTextColor
        self.statusLabel.text = viewModel.status
        self.rejectStatusLabel.text = viewModel.rejectStatus
        self.priceLabel.text = viewModel.price
        self.dateTimeLabel.text = viewModel.dateTime
        self.addressLabel.text = viewModel.address
    }
}
