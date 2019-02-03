//
//  MediaData.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

struct MediaData {
    
    // MARK: - Instance Properties
    
    let key: String?
    let filename: String
    let data: Data?
    let mimeType: String
    
    // MARK: - Initializers
    
    init(image: UIImage, key: String? = nil, imageName: String, mimeType: MimeType = .jpeg) {
        self.key = key
        self.mimeType = mimeType.rawValue
        self.filename = imageName
        self.data = image.jpegData(compressionQuality: 1)
    }
}
