//
//  DefaultImagePicker.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class DefaultImagePicker: NSObject, ImagePicker {

    // MARK: - Instance Properties

    private var onImageSelected: ((UIImage) -> Void)?

    // MARK: - Instance Methods

    private func takePhoto(from viewController: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return Log.w("Camera is not available")
        }

        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        viewController.present(imagePicker, animated: true)
    }

    private func selectPhoto(from viewController: UIViewController) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        viewController.present(imagePicker, animated: true)
    }

    // MARK: - ImagePicker

    func presentPickerActionSheet(from viewController: UIViewController, selectedImage: @escaping ((UIImage) -> Void)) {
        self.onImageSelected = selectedImage

        UIAlertController.Builder()
            .preferredStyle(.actionSheet)
            .withTitle("Change Photo".localized())
            .addDefaultAction(withTitle: "From Camera".localized(), handler: { [unowned self] action in
                self.takePhoto(from: viewController)
            }).addDefaultAction(withTitle: "From Gallery".localized(), handler: { [unowned self] action in
                self.selectPhoto(from: viewController)
            })
            .addCancelAction()
            .show(in: viewController)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension DefaultImagePicker: UIImagePickerControllerDelegate {

    // MARK: - Instance Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }

        self.onImageSelected?(selectedImage)
    }
}

// MARK: - UINavigationControllerDelegate

extension DefaultImagePicker: UINavigationControllerDelegate { }
