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
    
    fileprivate enum Segues {
        
        // MARK: - Type Properties
        
        static let finishVerificationCode = "FinishVerificationCode"
    }
    
    // MARK: - Instance Properties
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var verificationCodeTextField: UITextField!
    @IBOutlet fileprivate weak var verifyButton: PrimaryButton!
    
    @IBOutlet fileprivate weak var bottomSpacerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: -
    
    fileprivate var phoneNumber: String?
    
    // MARK: - Initializers
    
    deinit {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Instance Methods
    
    @IBAction func onVerifyButtonTouchUpInside(_ sender: PrimaryButton) {
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
            viewController.performSegue(withIdentifier: Segues.finishVerificationCode, sender: viewController)
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }
            
            viewController.stopAnimating()
            viewController.showMessage(withError: error)
        })
    }
    
    @objc fileprivate func textFieldDidChange(_ sender: UITextField) {
        self.updateVerifyButtonState()
    }
    
    fileprivate func updateVerifyButtonState() {
        self.verifyButton.isEnabled = self.verificationCodeTextField.text.isNotEmpty
    }
    
    // MARK: -
    
    fileprivate func apply(phoneNumber: String) {
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
    
    func apply(dictionary: [String : Any]) {
        guard let phoneNumber = dictionary["phoneNumber"] as? String else {
            return
        }
        
        self.apply(phoneNumber: phoneNumber)
    }
}
