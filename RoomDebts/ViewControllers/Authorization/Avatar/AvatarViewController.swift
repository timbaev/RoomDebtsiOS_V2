//
//  AvatarViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 01/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AvatarViewController: LoggedViewController, ErrorMessagePresenter, NVActivityIndicatorViewable {
    
    // MARK: - Nested Types
    
    fileprivate enum Segues {
        
        // MARK: - Type Properties
        
        static let finishAutorization = "FinishAutorization"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var addPhotoButton: UIButton!
    @IBOutlet fileprivate weak var doneButton: PrimaryButton!
    
    // MARK: -
    
    fileprivate var isImageSelected = false
    
    // MARK: - Instance Methods
    
    @IBAction func onAddPhotoButtonTouchUpInside(_ sender: UIButton) {
        Log.i(String(describing: sender.title(for: .normal)))
        
        let actionSheet = UIAlertController(title: "Add Photo".localized(), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "From Camera".localized(), style: .default) { [unowned self] action in
            self.takePhoto()
        }
        
        let galleryAction = UIAlertAction(title: "From Gallery".localized(), style: .default) { [unowned self] action in
            self.selectPhoto()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func onDoneButtonTouchUpInside(_ sender: PrimaryButton) {
         Log.i(String(describing: sender.title(for: .normal)))
        
        if self.isImageSelected {
            guard let image = self.avatarImageView.image else {
                return
            }
            
            self.startAnimating(type: .ballScaleMultiple)
            
            Services.accountService.uploadAvatar(image: image, success: { [weak self] in
                guard let viewController = self else {
                    return
                }
                
                viewController.stopAnimating()
                viewController.performSegue(withIdentifier: Segues.finishAutorization, sender: self)
            }, failure: { [weak self] error in
                guard let viewController = self else {
                    return
                }
                
                viewController.stopAnimating()
                viewController.showMessage(withError: error)
            })
        } else {
            self.performSegue(withIdentifier: Segues.finishAutorization, sender: self)
        }
    }
    
    fileprivate func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return Log.w("Camera is not available")
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        self.present(imagePicker, animated: true)
    }
    
    fileprivate func selectPhoto() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AvatarViewController: UIImagePickerControllerDelegate {
    
    // MARK: - Instance Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        self.avatarImageView.image = info[.originalImage] as? UIImage
        
        self.isImageSelected = true
    }
}

// MARK: - UINavigationControllerDelegate

extension AvatarViewController: UINavigationControllerDelegate { }
