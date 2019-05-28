//
//  UIImageExtension.swift
//  Tools
//
//  Created by Oleg Gorelov on 17/05/2019.
//  Copyright © 2019 Apptitude. All rights reserved.
//

import UIKit

extension UIImage {

    // MARK: - Instance Methods

    func resized(maxSideSize: CGFloat = 1_000) -> UIImage {
        guard self.size.width > maxSideSize || self.size.height > maxSideSize else {
            return self
        }

        let aspectRatio = self.size.width / self.size.height

        var scale: CGFloat

        if aspectRatio > 0 {
            scale = maxSideSize / self.size.width
        } else {
            scale = maxSideSize / self.size.height
        }

        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? self
    }
}
