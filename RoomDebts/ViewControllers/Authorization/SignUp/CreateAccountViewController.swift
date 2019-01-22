//
//  CreateAccountViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter

class CreateAccountViewController: LoggedViewController {
    
    // MARK: - Nested Types
    
    fileprivate enum Constants {
        
        // MARK: - Type Properties
        
        static let phoneNumberLength = 10
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet fileprivate weak var phoneNumberTextField: PhoneFormattedTextField!
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var nextButton: PrimaryButton!
    
    @IBOutlet fileprivate var textFields: [UITextField]!
    
    @IBOutlet fileprivate weak var bottomSpacerHeightConstraint: NSLayoutConstraint!
    
    // MARK: -
    
    fileprivate(set) var shouldApplyData = true
    
    // MARK: - Initializers
    
    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Instance Methods
    
    @objc fileprivate func onTextFieldDidChange(_ sender: UITextField) {
        Log.i(sender.text ?? "")
        
        self.updateNextButtonState()
    }
    
    @objc fileprivate func onToolbarDoneButtonTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i(sender.title ?? "")
        
        self.phoneNumberTextField.resignFirstResponder()
    }
    
    fileprivate func updateNextButtonState() {
        if self.firstNameTextField.text.isNotEmpty, self.lastNameTextField.text.isNotEmpty, self.phoneNumberTextField.phoneNumberWithoutPrefix()?.count == Constants.phoneNumberLength {
            self.nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
    
    // MARK: - UIVeiwController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name".localized(), attributes: [.font: Fonts.regular(ofSize: 17), .foregroundColor: Colors.white.withAlphaComponent(0.5)])
        
        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name".localized(), attributes: [.font: Fonts.regular(ofSize: 17), .foregroundColor: Colors.white.withAlphaComponent(0.5)])
        
        self.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number".localized(), attributes: [.font: Fonts.regular(ofSize: 17), .foregroundColor: Colors.white.withAlphaComponent(0.5)])
        
        self.firstNameTextField.addTarget(self, action: #selector(self.onTextFieldDidChange(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(self.onTextFieldDidChange(_:)), for: .editingChanged)
        
        self.phoneNumberTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        self.phoneNumberTextField.prefix = "+7 "
        self.phoneNumberTextField.textDidChangeBlock = { [unowned self] textField in
            self.updateNextButtonState()
        }
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        doneToolbar.barStyle = .black
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(self.onToolbarDoneButtonTouchUpInside(_:)))
        
        doneButton.tintColor = Colors.white
        
        let items = [flexSpace, doneButton]
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.phoneNumberTextField.inputAccessoryView = doneToolbar
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

extension CreateAccountViewController: KeyboardScrollableHandler {
    
    // MARK: - Instance Methods
    
    var scrollableView: UIScrollView {
        return self.scrollView
    }
}

// MARK: - KeyboardHandler

extension CreateAccountViewController: KeyboardHandler {
    
    // MARK: - Instance Methods
    
    func handle(keyboardHeight: CGFloat, view: UIView) {
        self.bottomSpacerHeightConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UITextFieldDelegate

extension CreateAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let currentIndex = self.textFields.firstIndex(of: textField) else {
            return false
        }
        
        textField.resignFirstResponder()
        
        let hasNext = (currentIndex + 1 <= self.textFields.count - 1)
        if hasNext {
            self.textFields[currentIndex + 1].becomeFirstResponder()
        }
        
        return true
    }
}
