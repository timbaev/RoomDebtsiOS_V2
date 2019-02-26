//
//  UserTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var avatarImageView: RoundedImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!

    // MARK: -

    var avatar: UIImage? {
        get {
            return self.avatarImageView.image
        }

        set {
            self.avatarImageView.image = newValue
        }
    }

    var name: String? {
        get {
            return self.nameLabel.text
        }

        set {
            self.nameLabel.text = newValue
        }
    }

    var isLastRow: Bool {
        get {
            return self.separatorView.isHidden
        }

        set {
            self.separatorView.isHidden = newValue
        }
    }

    // MARK: -

    var avatarImageViewTarget: UIImageView {
        return self.avatarImageView
    }
}
