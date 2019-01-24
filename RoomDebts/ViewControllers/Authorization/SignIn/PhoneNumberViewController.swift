//
//  SignInViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter

class PhoneNumberViewController: LoggedViewController {
    
    // MARK: - Nested Types
    
    fileprivate enum Constants {
        
        // MARK: - Type Properties
        
        static let phoneNumberLength = 10
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var phoneNumberTextField: PhoneFormattedTextField!
    @IBOutlet fileprivate weak var sendCodeButton: PrimaryButton!
    
    @IBOutlet fileprivate weak var bottomSpacerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initializers
    
    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Instance Methods
    
    fileprivate func updateSendCodeButtonState() {
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
