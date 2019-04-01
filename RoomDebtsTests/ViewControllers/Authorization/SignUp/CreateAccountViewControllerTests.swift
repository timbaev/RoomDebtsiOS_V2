//
//  CreateAccountViewControllerTests.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import XCTest
import SwiftPhoneNumberFormatter
@testable import RoomDebts

fileprivate class DictionaryReceiverViewController: UIViewController, DictionaryReceiver {

    // MARK: - Instance Properties

    fileprivate(set) var applyCalled = false
    fileprivate(set) var receivedData: [String: Any] = [:]

    // MARK: - Instance Methods

    func apply(dictionary: [String : Any]) {
        self.applyCalled = true
        self.receivedData = dictionary
    }
}

class CreateAccountViewControllerTests: XCTestCase {

    // MARK: - Instance Properties

    var sut: CreateAccountViewController!
    var window: UIWindow!

    // MARK: - Instance Methods

    private func setupWelcomeViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "SignUp", bundle: bundle)

        let initialViewController = storyboard.instantiateInitialViewController()

        if let navigationController = initialViewController as? UINavigationController {
            self.sut = navigationController.viewControllers.first as? CreateAccountViewController
        } else {
            self.sut = initialViewController as? CreateAccountViewController
        }
    }

    private func loadView() {
        self.window.addSubview(self.sut.view)

        RunLoop.current.run(until: Date())
    }

    // MARK: -

    func testConfigTextFieldsPlaceholder() {
        // arrange
        let expectedFirstNameAttributedPlaceholder = NSAttributedString(string: "First Name".localized(), attributes: [.font: Fonts.regular(ofSize: 17), .foregroundColor: Colors.white.withAlphaComponent(0.5)])
        let expectedLastNameAttributedPlaceholder = NSAttributedString(string: "Last Name".localized(), attributes: [.font: Fonts.regular(ofSize: 17), .foregroundColor: Colors.white.withAlphaComponent(0.5)])
        let expectedPhoneNumberAttributedPlaceholder = NSAttributedString(string: "Phone Number".localized(), attributes: [.font: Fonts.regular(ofSize: 17), .foregroundColor: Colors.white.withAlphaComponent(0.5)])

        // act
        self.loadView()

        // assert
        XCTAssertEqual(expectedFirstNameAttributedPlaceholder, self.sut.firstNameTextField.attributedPlaceholder)
        XCTAssertEqual(expectedLastNameAttributedPlaceholder, self.sut.lastNameTextField.attributedPlaceholder)
        XCTAssertEqual(expectedPhoneNumberAttributedPlaceholder, self.sut.phoneNumberTextField.attributedPlaceholder)
    }

    func testConfigTextFieldsTarget() {
        // arrange
        let expectedTarget = AnyHashable(self.sut!)

        // act
        self.loadView()

        // assert
        XCTAssertTrue(self.sut.firstNameTextField.allTargets.contains(expectedTarget))
        XCTAssertTrue(self.sut.lastNameTextField.allTargets.contains(expectedTarget))
    }

    func testConfigPhoneNumberTextField() {
        // arrange
        let expectedDefaultPhoneFormat = "(###) ###-##-##"
        let expectedPrefix = "+7 "

        // act
        self.loadView()

        // assert
        XCTAssertEqual(expectedDefaultPhoneFormat, self.sut.phoneNumberTextField.config.defaultConfiguration.phoneFormat)
        XCTAssertEqual(expectedPrefix, self.sut.phoneNumberTextField.prefix)
        XCTAssertNotNil(self.sut.phoneNumberTextField.textDidChangeBlock)
    }

    func testConfigPhoneNumberTextFieldToolbar() {
        // arrange
        let expectedBarStyle = UIBarStyle.black
        let expectedItemsCount = 2
        let expectedDoneButtonTitle = "Done".localized()
        let expectedDoneTintColor = Colors.white

        // act
        self.loadView()

        // assert
        XCTAssertNotNil(self.sut.phoneNumberTextField.inputAccessoryView)
        XCTAssertTrue(self.sut.phoneNumberTextField.inputAccessoryView is UIToolbar)

        let toolbar = self.sut.phoneNumberTextField.inputAccessoryView as! UIToolbar

        XCTAssertEqual(expectedBarStyle, toolbar.barStyle)
        XCTAssertEqual(expectedItemsCount, toolbar.items?.count)
        XCTAssertEqual(expectedDoneButtonTitle, toolbar.items?.last?.title)
        XCTAssertEqual(expectedDoneTintColor, toolbar.items?.last?.tintColor)
    }

    // MARK: -

    func testHandleKeyboardShowing() {
        // arrange
        let keyboardRect = CGRect(x: 0, y: 0, width: 50, height: 100)

        // act
        self.loadView()

        NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: [UIResponder.keyboardFrameEndUserInfoKey: keyboardRect])

        // assert
        XCTAssertTrue(self.sut.bottomSpacerHeightConstraint.constant > 0)
    }

    func testHandleKeyboardHiding() {
        // arrange
        self.loadView()

        self.sut.bottomSpacerHeightConstraint.constant = 15

        // act
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)

        // assert
        XCTAssertTrue(self.sut.bottomSpacerHeightConstraint.constant == 0)
    }

    // MARK: -

    func testUnsubscribeFromKeyboardNotifications() {
        // arrange
        let expectedConstant: CGFloat = 100

        // act
        self.loadView()

        self.sut.bottomSpacerHeightConstraint.constant = expectedConstant
        self.sut.unsubscribeFromKeyboardNotifications()

        let expectation = self.expectation(forNotification: UIResponder.keyboardWillHideNotification, object: self.sut, handler: nil)
        expectation.isInverted = true

        // assert
        self.waitForExpectations(timeout: 1.0, handler: { error in
            XCTAssertNil(error)
        })
    }

    // MARK: -

    func testPrepareForSegueForShowVerificationCode() {
        // arrange
        let destination = DictionaryReceiverViewController()
        let expectedPhoneNumber = "+71234567890"
        let expectedPhoneNumberKey = "phoneNumber"

        let expectedSourceKey = "source"
        let expectedSource = VerificationCodeSourceScreen.signUp

        let segue = UIStoryboardSegue(identifier: "ShowVerificationCode", source: self.sut, destination: destination)

        // act
        self.sut.prepare(for: segue, sender: expectedPhoneNumber)

        // assert
        XCTAssertTrue(destination.applyCalled)
        XCTAssertTrue(destination.receivedData.keys.contains(expectedPhoneNumberKey))
        XCTAssertTrue(destination.receivedData.keys.contains(expectedSourceKey))
        XCTAssertEqual(expectedPhoneNumber, destination.receivedData[expectedPhoneNumberKey] as? String)
        XCTAssertEqual(expectedSource, destination.receivedData[expectedSourceKey] as? VerificationCodeSourceScreen)
    }

    func testPrepareForSegueForShowVerificationCodeWithNavigationController() {
        // arrange
        let destination = DictionaryReceiverViewController()
        let navController = UINavigationController(rootViewController: destination)
        let expectedPhoneNumber = "+71234567890"
        let expectedPhoneNumberKey = "phoneNumber"

        let expectedSourceKey = "source"
        let expectedSource = VerificationCodeSourceScreen.signUp

        let segue = UIStoryboardSegue(identifier: "ShowVerificationCode", source: self.sut, destination: navController)

        // act
        self.sut.prepare(for: segue, sender: expectedPhoneNumber)

        // assert
        XCTAssertTrue(destination.applyCalled)
        XCTAssertTrue(destination.receivedData.keys.contains(expectedPhoneNumberKey))
        XCTAssertTrue(destination.receivedData.keys.contains(expectedSourceKey))
        XCTAssertEqual(expectedPhoneNumber, destination.receivedData[expectedPhoneNumberKey] as? String)
        XCTAssertEqual(expectedSource, destination.receivedData[expectedSourceKey] as? VerificationCodeSourceScreen)
    }

    func testPrepareForSegueForShowVerificationCodeWithoutPhoneNumber() {
        // arrange
        let destination = DictionaryReceiverViewController()

        let segue = UIStoryboardSegue(identifier: "ShowVerificationCode", source: self.sut, destination: destination)

        // act
        self.expectFatalError(testcase: {
            self.sut.prepare(for: segue, sender: nil)
        })
    }

    func testPrepareForSegueForDefaultSegue() {
        // arrange
        let destination = DictionaryReceiverViewController()

        let segue = UIStoryboardSegue(identifier: "OtherSegue", source: self.sut, destination: destination)

        // act
        self.sut.prepare(for: segue, sender: nil)

        // assert
        XCTAssertFalse(destination.applyCalled)
    }

    // MARK: -

    func testKeyboardScrollableHandlerScrollableView() {
        // arrange
        self.loadView()

        let expectedScollableView = self.sut.scrollView

        // act
        let scrollableView = self.sut.scrollableView

        // assert
        XCTAssertEqual(expectedScollableView, scrollableView)
    }

    // MARK: -

    func testTextFieldShouldReturn() {
        // arrange
        self.loadView()

        self.sut.firstNameTextField.becomeFirstResponder()

        // act
        let shouldReturn = self.sut.textFieldShouldReturn(self.sut.firstNameTextField)

        // assert
        XCTAssertTrue(shouldReturn)
        XCTAssertFalse(self.sut.firstNameTextField.isFirstResponder)
        XCTAssertTrue(self.sut.lastNameTextField.isFirstResponder)
    }

    func testTextFieldShouldReturnWithNonexistenceTextField() {
        // arrange
        self.loadView()

        // act
        let shouldReturn = self.sut.textFieldShouldReturn(UITextField())

        // assert
        XCTAssertFalse(shouldReturn)
    }

    // MARK: -

    func testDeinit() {
        // arrange
        var sut: CreateAccountViewController? = CreateAccountViewController()

        sut?.subscribeToKeyboardNotifications()

        // act
        sut = nil

        // assert
        let expectation = self.expectation(forNotification: UIResponder.keyboardWillHideNotification, object: self.sut, handler: nil)
        expectation.isInverted = true

        self.waitForExpectations(timeout: 1.0, handler: { error in
            XCTAssertNil(error)
        })
    }

    // MARK: -

    func testUpdateNextButtonStateToDisabledAfterFirstNameTextFieldChanged() {
        // arrange
        self.loadView()

        self.sut.nextButton.isEnabled = true

        // act
        self.sut.firstNameTextField.sendActions(for: .editingChanged)

        // assert
        XCTAssertFalse(self.sut.nextButton.isEnabled)
    }

    func testUpdateNextButtonStateToEnabledAfterFirstNameTextFieldChanged() {
        // arrange
        self.loadView()

        self.sut.nextButton.isEnabled = false

        self.sut.firstNameTextField.text = "Text"
        self.sut.lastNameTextField.text = "Text"
        self.sut.phoneNumberTextField.formattedText = "9172513598"

        // act
        self.sut.firstNameTextField.sendActions(for: .editingChanged)

        // assert
        XCTAssertTrue(self.sut.nextButton.isEnabled)
    }

    func testUpdateNextButtonStateToDisabledAfterLastNameTextFieldChanged() {
        // arrange
        self.loadView()

        self.sut.nextButton.isEnabled = true

        // act
        self.sut.lastNameTextField.sendActions(for: .editingChanged)

        // assert
        XCTAssertFalse(self.sut.nextButton.isEnabled)
    }

    func testUpdateNextButtonStateToEnabledAfterLastNameTextFieldChanged() {
        // arrange
        self.loadView()

        self.sut.nextButton.isEnabled = false

        self.sut.firstNameTextField.text = "Text"
        self.sut.lastNameTextField.text = "Text"
        self.sut.phoneNumberTextField.formattedText = "9172513598"

        // act
        self.sut.firstNameTextField.sendActions(for: .editingChanged)

        // assert
        XCTAssertTrue(self.sut.nextButton.isEnabled)
    }

    func testUpdateNextButtonStateToDisabledAfterPhoneNumberTextFieldChanged() {
        // arrange
        self.loadView()

        self.sut.nextButton.isEnabled = true

        // act
        self.sut.phoneNumberTextField.textDidChangeBlock?(self.sut.phoneNumberTextField)

        // assert
        XCTAssertFalse(self.sut.nextButton.isEnabled)
    }

    func testUpdateNextButtonStateToEnabledAfterPhoneNumberTextFieldChanged() {
        // arrange
        self.loadView()

        self.sut.nextButton.isEnabled = false

        self.sut.firstNameTextField.text = "Text"
        self.sut.lastNameTextField.text = "Text"
        self.sut.phoneNumberTextField.formattedText = "1234567890"

        // act
        self.sut.phoneNumberTextField.textDidChangeBlock?(self.sut.phoneNumberTextField)

        // assert
        XCTAssertTrue(self.sut.nextButton.isEnabled)
    }

    // MARK: -

    func testOnToolbarDoneButtonTouchUpInside() {
        // arrange
        self.loadView()

        self.sut.phoneNumberTextField.becomeFirstResponder()

        let toolbar = self.sut.phoneNumberTextField.inputAccessoryView as! UIToolbar

        guard let doneButton = toolbar.items?.last else {
            return XCTFail()
        }

        // act
        _ = doneButton.target?.perform(doneButton.action, with: nil)

        // assert
        XCTAssertFalse(self.sut.phoneNumberTextField.isFirstResponder)
    }

    // MARK: -

    func testCreateUserAfterOnNextButtonTouchUpInside() {
        // arrange
        let accountService = MockAccountService()

        self.sut.accountService = accountService

        self.loadView()

        self.sut.firstNameTextField.text = "Test"
        self.sut.lastNameTextField.text = "Test"
        self.sut.phoneNumberTextField.formattedText = "1234567890"

        // act
        self.sut.nextButton.sendActions(for: .touchUpInside)

        // assert
        XCTAssertTrue(accountService.createCalled)
    }

    func testReturnIfFirstNameTextFieldIsEmptyAfterOnNextButtonTouchUpInside() {
        // arrange
        let accountService = MockAccountService()

        self.sut.accountService = accountService

        self.loadView()

        self.sut.firstNameTextField.text = nil

        // act
        self.sut.nextButton.sendActions(for: .touchUpInside)

        // assert
        XCTAssertFalse(accountService.createCalled)
    }

    func testReturnIfLastNameTextFieldIsEmptyAfterOnNextButtonTouchUpInside() {
        // arrange
        let accountService = MockAccountService()

        self.sut.accountService = accountService

        self.loadView()

        self.sut.firstNameTextField.text = "Test"
        self.sut.lastNameTextField.text = nil

        // act
        self.sut.nextButton.sendActions(for: .touchUpInside)

        // assert
        XCTAssertFalse(accountService.createCalled)
    }

    func testReturnIfPhoneNumberTextFieldIsEmptyAfterOnNextButtonTouchUpInside() {
        // arrange
        let accountService = MockAccountService()

        self.sut.accountService = accountService

        self.loadView()

        self.sut.firstNameTextField.text = "Test"
        self.sut.lastNameTextField.text = "Test"
        self.sut.phoneNumberTextField.text = nil

        // act
        self.sut.nextButton.sendActions(for: .touchUpInside)

        // assert
        XCTAssertFalse(accountService.createCalled)
    }
    
    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        self.window = UIWindow()

        self.setupWelcomeViewController()
    }

    override func tearDown() {
        self.window = nil

        super.tearDown()
    }
}
