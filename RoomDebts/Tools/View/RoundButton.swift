//
//  RoundButton.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 15/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

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
