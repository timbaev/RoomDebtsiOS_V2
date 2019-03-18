//
//  PlaceholderTextView.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 05/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

@IBDesignable class PlaceholderTextView: UIView {

    // MARK: - Instance Properties

    private var textView = UITextView()
    private var placeholderLabel = UILabel()

    // MARK: -

    @IBInspectable var placeholderText: String? = nil {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var textColor: UIColor = Colors.white {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var font: UIFont = Fonts.regular(ofSize: 17) {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var scrolling: Bool = false {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var textViewBackgroundColor: UIColor? = Colors.clear {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var textViewTintColor: UIColor = Colors.white {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var text: String {
        get {
            return self.textView.text
        }

        set {
            self.textView.text = newValue
            self.updatePlaceholderLabelState()
        }
    }

    // MARK: -

    var onDoneButtonClick: (() -> Void)?
    var textViewDidChange: ((UITextView) -> Void)?

    // MARK: -

    var textViewTarget: UITextView {
        return self.textView
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

    private func applyState() {
        self.placeholderLabel.text = self.placeholderText
        self.placeholderLabel.font = self.font

        self.textView.text = self.text
        self.textView.textColor = self.textColor
        self.textView.font = self.font
        self.textView.isScrollEnabled = self.scrolling
        self.textView.backgroundColor = self.textViewBackgroundColor
        self.textView.tintColor = self.textViewTintColor
    }

    private func initialize() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.delegate = self
        self.textView.returnKeyType = .done
        self.textView.keyboardAppearance = .dark

        self.addSubview(self.textView)

        self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.placeholderLabel.textColor = Colors.placeholder

        self.addSubview(self.placeholderLabel)

        NSLayoutConstraint.activate([self.textView.topAnchor.constraint(equalTo: self.topAnchor),
                                     self.textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     self.textView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])

        NSLayoutConstraint.activate([self.placeholderLabel.topAnchor.constraint(equalTo: self.textView.topAnchor, constant: 7),
                                     self.placeholderLabel.leadingAnchor.constraint(equalTo: self.textView.leadingAnchor, constant: 5),
                                     self.placeholderLabel.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: self.textView.trailingAnchor, multiplier: -7)])
    }

    private func updatePlaceholderLabelState() {
        self.placeholderLabel.isHidden = self.textView.hasText
    }
}

// MARK: - UITextViewDelegate

extension PlaceholderTextView: UITextViewDelegate {

    // MARK: - Instance Methods

    func textViewDidChange(_ textView: UITextView) {
        self.updatePlaceholderLabelState()

        self.textViewDidChange?(textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.onDoneButtonClick?()

            return false
        }

        return true
    }
}
