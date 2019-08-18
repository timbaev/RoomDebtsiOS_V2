//
//  RoundLabel.swift
//  Friendsta
//
//  Created by Timur Shafigullin on 19/07/2019.
//  Copyright © 2019 Decision Accelerator. All rights reserved.
//

import UIKit

@IBDesignable class RoundLabel: UILabel {

    // MARK: - Initializers

    public override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)

        self.layer.masksToBounds = true
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.layer.masksToBounds = true
    }

    // MARK: - Instance Methods

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = min(self.frame.width, self.frame.height) * 0.5
    }
}
