//
//  ReviewTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var reviewStatusImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    // MARK: -

    var reviewStatusImage: UIImage? {
        get {
            return self.reviewStatusImageView.image
        }

        set {
            self.reviewStatusImageView.image = newValue
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

    var status: String? {
        get {
            return self.statusLabel.text
        }

        set {
            self.statusLabel.text = newValue
        }
    }

    var message: String? {
        get {
            return self.messageLabel.text
        }

        set {
            self.messageLabel.text = newValue
        }
    }

    var messageIsHidden: Bool {
        get {
            return self.messageLabel.isHidden
        }

        set {
            self.messageLabel.isHidden = newValue
        }
    }
}
