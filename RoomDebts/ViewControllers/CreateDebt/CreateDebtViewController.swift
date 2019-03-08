//
//  CreateDebtViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 05/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CreateDebtViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let creatorSegmentIndex = 0
        static let opponentSegmentIndex = 1
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var currencyView: CurrencyView!
    @IBOutlet private weak var dateTextField: TextField!
    @IBOutlet private weak var descriptionTextView: PlaceholderTextView!
    @IBOutlet private weak var debtorSegmentControl: GradientSegmentControl!

    @IBOutlet private weak var createButton: PrimaryButton!

    @IBOutlet private weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!

    // MARK: -

    private var textInputs: [UIView] = []

    private var conversation: Conversation?

    private(set) var shouldApplyData = true

    // MARK: - Instance Methods

    @IBAction private func onCancelButtonTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        self.dismiss(animated: true)
    }

    @objc private func onDatePickerValueChange(_ sender: UIDatePicker) {
        Log.i()

        self.dateTextField.text = DebtDateFormatter.shared.string(from: sender.date)

        self.updateCreateButtonState()
    }

    // MARK: -

    private func updateCreateButtonState() {
        self.createButton.isEnabled = (self.currencyView.textFieldTarget.hasText && self.dateTextField.hasText)
    }

    // MARK: -

    private func nextResponder(after textInput: UIView) {
        textInput.resignFirstResponder()

        guard let index = self.textInputs.firstIndex(of: textInput) else {
            return
        }

        let nextIndex = index + 1
        let hasNext = (nextIndex < self.textInputs.count)

        if hasNext {
            self.textInputs[nextIndex].becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
    }

    // MARK: -

    private func configTextInputs() {
        self.textInputs.append(self.currencyView.textFieldTarget)
        self.textInputs.append(self.dateTextField)
        self.textInputs.append(self.descriptionTextView.textViewTarget)

        self.currencyView.onNextButtonClick = { [unowned self] in
            self.nextResponder(after: self.currencyView.textFieldTarget)
        }

        self.currencyView.onTextFieldDidChange = { [unowned self] textField in
            self.updateCreateButtonState()
        }

        self.dateTextField.onNextButtonClick = { [unowned self] in
            self.nextResponder(after: self.dateTextField)
        }

        self.descriptionTextView.onDoneButtonClick = { [unowned self] in
            self.nextResponder(after: self.descriptionTextView.textViewTarget)
        }

        self.descriptionTextView.textViewDidChange = { [unowned self] textView in
            let contentSize = textView.sizeThatFits(textView.bounds.size)

            if contentSize.height != self.descriptionTextViewHeightConstraint.constant {
                self.descriptionTextViewHeightConstraint.constant = contentSize.height
            }
        }
    }

    private func configDatePicker() {
        let datePicker = UIDatePicker()

        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = Colors.dark

        datePicker.setValue(Colors.white, forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(self.onDatePickerValueChange(_:)), for: .valueChanged)

        self.dateTextField.inputView = datePicker
    }

    // MARK: -

    private func apply(conversation: Conversation) {
        Log.i(conversation.uid)

        self.conversation = conversation

        if self.isViewLoaded {
            self.debtorSegmentControl.setTitle(conversation.creator?.firstName,
                                               forSegmentAt: Constants.creatorSegmentIndex)

            self.debtorSegmentControl.setTitle(conversation.opponent?.firstName,
                                               forSegmentAt: Constants.opponentSegmentIndex)

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldApplyData = true

        self.configTextInputs()
        self.configDatePicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let conversation = self.conversation {
            self.apply(conversation: conversation)
        }

        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - DictionaryReceiver

extension CreateDebtViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let conversation = dictionary["conversation"] as? Conversation else {
            return
        }

        self.apply(conversation: conversation)
    }
}

// MARK: - KeyboardScrollableHandler

extension CreateDebtViewController: KeyboardScrollableHandler {

    // MARK: - Instance Properties

    var scrollableView: UIScrollView {
        return self.scrollView
    }
}
