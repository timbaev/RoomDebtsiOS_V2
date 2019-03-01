//
//  PhoneNumberViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter
import NVActivityIndicatorView

class PhoneNumberViewController: LoggedViewController, NVActivityIndicatorViewable, ErrorMessagePresenter {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let phoneNumberLength = 10
    }

    // MARK: -

    private enum Segues {

        // MARK: - Type Properties

        static let showVerificationCode = "ShowVerificationCode"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var phoneNumberTextField: PhoneFormattedTextField!
    @IBOutlet private weak var sendCodeButton: PrimaryButton!

    @IBOutlet private weak var bottomSpacerViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Instance Methods

    @IBAction private func onSendButtonTouchUpInside(_ sender: PrimaryButton) {
        Log.i(sender.title(for: .normal) ?? "")

        guard let phoneNumber = self.phoneNumberTextField.phoneNumber() else {
            return
        }

        self.startAnimating(type: .ballScaleMultiple)

        Services.accountService.signIn(phoneNumber: phoneNumber, success: { [weak self] in
            self?.stopAnimating()
            self?.performSegue(withIdentifier: Segues.showVerificationCode, sender: phoneNumber)
        }, failure: { [weak self] error in
            self?.stopAnimating()
            self?.showMessage(withError: error)
        })
    }

    private func updateSendCodeButtonState() {
        self.sendCodeButton.isEnabled = (self.phoneNumberTextField.phoneNumberWithoutPrefix()?.count == Constants.phoneNumberLength)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.phoneNumberTextField.becomeFirstResponder()
        self.phoneNumberTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        self.phoneNumberTextField.prefix = "+7 "
        self.phoneNumberTextField.textDidChangeBlock = { [unowned self] textField in
            self.updateSendCodeButtonState()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardNotifications()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let dictionaryReceiver: DictionaryReceiver?

        if let navigationController = segue.destination as? UINavigationController {
            dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
        } else {
            dictionaryReceiver = segue.destination as? DictionaryReceiver
        }

        switch segue.identifier {
        case Segues.showVerificationCode:
            guard let phoneNumber = sender as? String else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["phoneNumber": phoneNumber, "source": VerificationCodeSourceScreen.signIn])
            }

        default:
            break
        }
    }
}

// MARK: - KeyboardScrollableHandler

extension PhoneNumberViewController: KeyboardScrollableHandler {

    // MARK: - Instance Properties

    var scrollableView: UIScrollView {
        return self.scrollView
    }
}

extension PhoneNumberViewController: KeyboardHandler {

    // MARK: - Instance Methods

    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpacerViewHeightConstraint.constant = keyboardHeight

        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
