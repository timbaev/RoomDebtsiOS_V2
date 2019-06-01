//
//  AddParticipantTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class AddParticipantTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var avatarImageView: RoundedImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var checkmarkImageView: UIImageView!

    // MARK: - UITableViewCell

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.checkmarkImageView.image = selected ? #imageLiteral(resourceName: "CheckmarkCheckedIcon.pdf") : #imageLiteral(resourceName: "CheckmarkUncheckedIcon.pdf")
    }
}

// MARK: - ConfigurableCell

extension AddParticipantTableViewCell: ConfigurableCell {

    // MARK: - Instance Properties

    var targetImageView: UIImageView? {
        return self.avatarImageView
    }

    // MARK: - Instance Methods

    func configure(data viewModel: AddParticipantViewModel) {
        self.nameLabel.text = viewModel.fullName
        self.nameLabel.textColor = viewModel.nameTextColor

        self.isUserInteractionEnabled = viewModel.isUserInteractionEnabled
    }
}
