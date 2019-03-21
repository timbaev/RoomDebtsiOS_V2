//
//  VerificationCodeViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 23/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VerificationCodeViewController: LoggedViewController, NVActivityIndicatorViewable, ErrorMessagePresenter {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let finishVerificationCode = "FinishVerificationCode"

        static let showAvatarPicker = "ShowAvatarPicker"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var verificationCodeTextField: UITextField!
    @IBOutlet private weak var verifyButton: PrimaryButton!

    @IBOutlet private weak var bottomSpacerViewHeightConstraint: NSLayoutConstraint!

    // MARK: -

    private var phoneNumber: String?

    private var sourceScreen: VerificationCodeSourceScreen?

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Instance Methods

    @IBAction private func onVerifyButtonTouchUpInside(_ sender: PrimaryButton) {
        Log.i(sender.title(for: .normal) ?? "")

        guard let code = self.verificationCodeTextField.text else {
            return
        }

        guard let phoneNumber = self.phoneNumber else {
            return
        }

        self.startAnimating(type: .ballScaleMultiple)

        Services.accountService.confirm(phoneNumber: phoneNumber, code: code, success: { [weak self] userAccount in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()

            switch viewController.sourceScreen {
            case .signUp?:
                viewController.performSegue(withIdentifier: Segues.showAvatarPicker, sender: viewController)

            case .signIn?:
                viewController.performSegue(withIdentifier: Segues.finishVerificationCode, sender: viewController)

            case .editProfile?:
                viewController.navigationController?.popViewController(animated: true)

            case nil:
                fatalError()
            }
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.showMessage(withError: error)
        })
    }

    @objc private func textFieldDidChange(_ sender: UITextField) {
        self.updateVerifyButtonState()
    }

    private func updateVerifyButtonState() {
        self.verifyButton.isEnabled = self.verificationCodeTextField.text.isNotEmpty
    }

    // MARK: -

    private func apply(phoneNumber: String) {
        Log.i(phoneNumber)
        self.phoneNumber = phoneNumber
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.verificationCodeTextField.becomeFirstResponder()
        self.verificationCodeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - KeyboardScrollableHandler

extension VerificationCodeViewController: KeyboardScrollableHandler {

    // MARK: - Instance Properties

    var scrollableView: UIScrollView {
        return self.scrollView
    }
}

// MARK: - KeyboardHandler

extension VerificationCodeViewController: KeyboardHandler {

    // MARK: - Instance Methods

    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpacerViewHeightConstraint.constant = keyboardHeight

        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension VerificationCodeViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let phoneNumber = dictionary["phoneNumber"] as? String else {
            return
        }

        if let sourceScreen = dictionary["source"] as? VerificationCodeSourceScreen {
            self.sourceScreen = sourceScreen
        }

        self.apply(phoneNumber: phoneNumber)
    }
}
