//
//  ImagePicker.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

protocol ImagePicker {

    // MARK: - Instance Methods

    func presentPickerActionSheet(from viewController: UIViewController, selectedImage: @escaping ((UIImage) -> Void))
}
