//
//  EditAccountViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter
import NVActivityIndicatorView

class EditAccountViewController: LoggedViewController, NVActivityIndicatorViewable, ErrorMessagePresenter {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let phoneNumberLength = 10
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var avatarImageView: RoundedImageView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: PhoneFormattedTextField!

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Instance Methods

    @objc private func onSaveBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()
    }

    @objc private func onTextFieldDidChange(_ textField: UITextField) {
        Log.i(textField.text)

        self.updateSaveBarButtonItemState()
    }

    @IBAction private func onChangePhotoTouchUpInside(_ sender: UIButton) {
        Log.i()

        UIAlertController.Builder()
            .preferredStyle(.actionSheet)
            .withTitle("Change Photo".localized())
            .addDefaultAction(withTitle: "From Camera".localized(), handler: { [unowned self] action in
                self.takePhoto()
            }).addDefaultAction(withTitle: "From Gallery".localized(), handler: { [unowned self] action in
                self.selectPhoto()
            })
            .addCancelAction()
            .show(in: self)
    }

    // MARK: -

    private func updateSaveBarButtonItemState() {
        let userAccount = Services.userAccount

        guard userAccount?.firstName != self.firstNameTextField.text
            || userAccount?.lastName != self.lastNameTextField.text
            || userAccount?.phoneNumber != self.phoneNumberTextField.phoneNumber() else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false

            return
        }

        if self.firstNameTextField.hasText && self.lastNameTextField.hasText && self.phoneNumberTextField.phoneNumberWithoutPrefix()?.count == Constants.phoneNumberLength {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    // MARK: -

    private func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return Log.w("Camera is not available")
        }

        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        self.present(imagePicker, animated: true)
    }

    private func selectPhoto() {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true)
    }

    // MARK: -

    private func config(userAccount: UserAccount) {
        Log.i(userAccount.uid)

        self.loadAvatarImage(for: userAccount)

        self.firstNameTextField.text = userAccount.firstName
        self.lastNameTextField.text = userAccount.lastName

        var phoneNumber = userAccount.phoneNumber

        phoneNumber?.removeFirst()

        self.phoneNumberTextField.formattedText = phoneNumber
    }

    private func configPhoneNumberTextField() {
        self.phoneNumberTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        self.phoneNumberTextField.prefix = "+7 "
        self.phoneNumberTextField.textDidChangeBlock = { [unowned self] textField in
            self.updateSaveBarButtonItemState()
        }
    }

    private func configSaveBarButtonItem() {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onSaveBarButtonItemTouchUpInside(_:)))

        saveBarButtonItem.tintColor = Colors.saveBarItem
        saveBarButtonItem.isEnabled = false

        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    private func configTextFieldTargets() {
        self.firstNameTextField.addTarget(self, action: #selector(self.onTextFieldDidChange(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(self.onTextFieldDidChange(_:)), for: .editingChanged)
    }

    // MARK: -

    private func loadAvatarImage(for userAccount: UserAccount) {
        if let imageURL = userAccount.avatarURL {
            ImageDownloader.shared.loadImage(for: imageURL, in: self.avatarImageView, placeholder: #imageLiteral(resourceName: "AvatarPlaceholder.pdf"))
        }
    }

    // MARK: -

    private func upload(image: UIImage) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.accountService.uploadAvatar(image: image, success: { [weak self] userAccount in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()

            viewController.avatarImageView.image = image
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.showMessage(withError: error)
        })
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configPhoneNumberTextField()
        self.configSaveBarButtonItem()
        self.configTextFieldTargets()

        if let userAccount = Services.userAccount {
            self.config(userAccount: userAccount)
        } else {
            fatalError()
        }

        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - KeyboardScrollableHandler

extension EditAccountViewController: KeyboardScrollableHandler {

    // MARK: - Instance Properties

    var scrollableView: UIScrollView {
        return self.scrollView
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditAccountViewController: UIImagePickerControllerDelegate {

    // MARK: - Instance Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }

        self.upload(image: selectedImage)
    }
}

// MARK: - UINavigationControllerDelegate

extension EditAccountViewController: UINavigationControllerDelegate { }
