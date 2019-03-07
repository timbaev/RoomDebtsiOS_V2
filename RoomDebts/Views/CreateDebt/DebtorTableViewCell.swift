//
//  DebtorTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 06/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class DebtorTableViewCell: UITableViewCell {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let creatorSegmentIndex = 0
        static let opponentSegmentIndex = 1
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var debtorLabel: UILabel!
    @IBOutlet private weak var segmentControl: GradientSegmentControl!

    // MARK: -

    var selectedSegmentIndex: Int {
        get {
            return self.segmentControl.selectedSegmentIndex
        }

        set {
            self.segmentControl.selectedSegmentIndex = newValue
        }
    }

    var creatorName: String? {
        get {
            return self.segmentControl.titleForSegment(at: Constants.creatorSegmentIndex)
        }

        set {
            self.segmentControl.setTitle(newValue, forSegmentAt: Constants.creatorSegmentIndex)
        }
    }

    var opponentName: String? {
        get {
            return self.segmentControl.titleForSegment(at: Constants.opponentSegmentIndex)
        }

        set {
            self.segmentControl.setTitle(newValue, forSegmentAt: Constants.opponentSegmentIndex)
        }
    }
}
