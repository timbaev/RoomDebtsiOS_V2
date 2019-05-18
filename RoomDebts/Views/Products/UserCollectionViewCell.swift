//
//  UserCollectionViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var avatarImageView: RoundedImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: -

    override var isSelected: Bool {
        didSet {
            self.applyState()
        }
    }

    // MARK: - Instance Methods

    private func applyState() {
        if self.isSelected {
            self.avatarImageView.layer.borderColor = Colors.selectedProductUser.cgColor

            self.nameLabel.font = Fonts.medium(ofSize: 12)
            self.nameLabel.textColor = Colors.selectedProductUser
        } else {
            self.avatarImageView.layer.borderColor = Colors.clear.cgColor

            self.nameLabel.font = Fonts.light(ofSize: 12)
            self.nameLabel.textColor = Colors.white
        }
    }

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()

        self.avatarImageView.layer.borderWidth = 2
    }
}

// MARK: - ConfigurableCell

extension UserCollectionViewCell: ConfigurableCell {

    // MARK: - Instance Properties

    var targetImageView: UIImageView? {
        return self.avatarImageView
    }

    // MARK: - Instance Methods

    func configure(data viewModel: UserViewModel) {
        self.nameLabel.text = viewModel.name
        self.nameLabel.font = viewModel.nameFont
        self.nameLabel.textColor = viewModel.nameColor

        self.avatarImageView.layer.borderColor = viewModel.borderColor.cgColor
    }
}
