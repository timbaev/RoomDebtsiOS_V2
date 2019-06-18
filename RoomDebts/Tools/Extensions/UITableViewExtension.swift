//
//  UITableViewExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

extension UITableView {

    // MARK: - Instance Methods

    func sizeFooterToFit() {
        guard let footerView = self.tableFooterView else {
            return
        }

        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
        }

        self.tableFooterView = footerView
    }
}
