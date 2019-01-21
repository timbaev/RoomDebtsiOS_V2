//
//  CreateAccountViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CreateAccountViewController: LoggedViewController {
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    @IBOutlet fileprivate weak var lastNameTextField: UITextField!
    @IBOutlet fileprivate weak var phoneNumberTextField: UITextField!
    
    @IBOutlet fileprivate weak var nextButton: PrimaryButton!
    
    // MARK: -
    
    fileprivate(set) var shouldApplyData = true
    
    // MARK: - Instance Methods
    
    @objc fileprivate func onTextFieldDidChange(_ sender: UITextField) {
        self.updateNextButtonState()
    }
    
    fileprivate func updateNextButtonState() {
        if self.firstNameTextField.text.isNotEmpty, self.lastNameTextField.text.isNotEmpty, self.phoneNumberTextField.text.isNotEmpty {
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
        self.phoneNumberTextField.addTarget(self, action: #selector(self.onTextFieldDidChange(_:)), for: .editingChanged)
    }
    
}
