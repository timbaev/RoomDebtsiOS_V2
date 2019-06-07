//
//  ParticipantTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 25/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var avatarImageView: RoundedImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var creatorLabel: UILabel!

    // MARK: - UITableViewCell

    override func prepareForReuse() {
        super.prepareForReuse()

        self.avatarImageView.image = nil
    }
}

// MARK: - ConfigurableCell

extension ParticipantTableViewCell: ConfigurableCell {

    // MARK: - Instance Properties

    var targetImageView: UIImageView? {
        return self.avatarImageView
    }

    // MARK: - Instance Methods

    func configure(data viewModel: ParticipantViewModel) {
        self.nameLabel.text = viewModel.name
        self.creatorLabel.isHidden = viewModel.isCreatorLabelHidden
    }
}
