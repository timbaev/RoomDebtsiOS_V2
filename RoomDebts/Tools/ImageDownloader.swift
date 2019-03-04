//
//  ImageDownloader.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Kingfisher

class ImageDownloader {

    // MARK: - Type Properties

    static let shared = ImageDownloader()

    // MARK: - Instance Methods

    func loadImage(for url: URL, in imageView: UIImageView, placeholder: UIImage? = nil) {
        var kf = imageView.kf

        kf.indicatorType = .activity
        kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.25))])
    }

    func cancelLoad(in imageView: UIImageView) {
        imageView.kf.cancelDownloadTask()
    }
}
