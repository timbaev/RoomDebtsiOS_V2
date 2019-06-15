//
//  TotalTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class TotalTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var avatarImageView: RoundedImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var reviewStatusImageView: UIImageView!
    @IBOutlet private weak var totalLabel: UILabel!

    // MARK: -

    var name: String? {
        get {
            return self.nameLabel.text
        }

        set {
            self.nameLabel.text = newValue
        }
    }

    var reviewStatusImage: UIImage? {
        get {
            return self.reviewStatusImageView.image
        }

        set {
            self.reviewStatusImageView.image = newValue
        }
    }

    var reviewStatusImageColor: UIColor {
        get {
            return self.reviewStatusImageView.tintColor
        }

        set {
            self.reviewStatusImageView.tintColor = newValue
        }
    }

    var total: String? {
        get {
            return self.totalLabel.text
        }

        set {
            self.totalLabel.text = newValue
        }
    }

    // MARK: -

    var imageViewTarget: UIImageView {
        return self.avatarImageView
    }
}
