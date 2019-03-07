//
//  CurrencyView.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 07/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

@IBDesignable class CurrencyView: UIView {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let separator = "."
    }

    // MARK: - Instance Properties

    private let currencySymbolLabel = UILabel()
    private let textField = TextField()

    // MARK: -

    @IBInspectable var textColor: UIColor = Colors.white {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var placeholderColor: UIColor = Colors.textPlaceholder {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var placeholder: String? = nil {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var currencySymbol: String? = nil {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var font: UIFont = Fonts.regular(ofSize: 17) {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var showToolbar: Bool = false {
        didSet {
            self.applyState()
        }
    }

    override var tintColor: UIColor! {
        didSet {
            self.applyState()
        }
    }

    var text: String? {
        get {
            return self.textField.text
        }

        set {
            self.textField.text = newValue
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    // MARK: - Instance Methods

    @objc private func textFieldDidChange(_ textField: UITextField) {
        self.updateCurrencySymbolLabelState()
    }

    private func updateCurrencySymbolLabelState() {
        if self.textField.hasText {
            self.currencySymbolLabel.textColor = self.textColor
        } else {
            self.currencySymbolLabel.textColor = Colors.textPlaceholder
        }
    }

    // MARK: -

    private func initialize() {
        self.currencySymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currencySymbolLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        self.addSubview(self.currencySymbolLabel)

        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.textField.keyboardType = .decimalPad
        self.textField.delegate = self
        self.textField.textAlignment = .right
        self.textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        self.addSubview(self.textField)

        NSLayoutConstraint.activate([self.currencySymbolLabel.topAnchor.constraint(equalTo: self.topAnchor),
                                     self.currencySymbolLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     self.currencySymbolLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)])

        NSLayoutConstraint.activate([self.textField.topAnchor.constraint(equalTo: self.topAnchor),
                                     self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     self.textField.trailingAnchor.constraint(equalTo: self.currencySymbolLabel.leadingAnchor)])
    }

    private func applyState() {
        self.currencySymbolLabel.textColor = self.textColor
        self.currencySymbolLabel.font = self.font
        self.currencySymbolLabel.text = self.currencySymbol

        self.textField.textColor = self.textColor
        self.textField.placeholderColor = self.placeholderColor
        self.textField.font = self.font
        self.textField.tintColor = self.tintColor
        self.textField.placeholder = self.placeholder
        self.textField.showToolbar = self.showToolbar

        self.updateCurrencySymbolLabelState()
    }
}

// MARK: - UITextFieldDelegate

extension CurrencyView: UITextFieldDelegate {

    // MARK: - Instance Methods

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }

        if text.contains(Constants.separator) {
            if string == Constants.separator {
                return false
            } else if textField.text?.components(separatedBy: Constants.separator)[1].count == 2 && range.length != 1 {
                return false
            }
        }

        return true
    }
}
