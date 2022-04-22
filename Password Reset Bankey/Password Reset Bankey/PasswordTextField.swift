//
//  PasswordTextFieldView.swift
//  Password Reset Bankey
//
//  Created by Yash Shah on 12/03/2022.
//

import UIKit

class PasswordTextField: UIView {
	let lockImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
	let textField = UITextField()
	let eyeButton = UIButton(type: .custom)

	let dividerView = UIView()
	let errorLabel = UILabel()

	let placeholderText: String

	init(placeholderText: String) {
		self.placeholderText = placeholderText
		super.init(frame: .zero)

		style()
		layout()
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	override var intrinsicContentSize: CGSize {
		CGSize(width: UIView.noIntrinsicMetric, height: 60)
	}
}

extension PasswordTextField {
	func style() {
		translatesAutoresizingMaskIntoConstraints = false

		lockImageView.translatesAutoresizingMaskIntoConstraints = false

		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.isSecureTextEntry = true
		textField.placeholder = placeholderText
		textField.delegate = self
		textField.keyboardType = .asciiCapable
		textField.attributedPlaceholder = NSAttributedString(
			string: placeholderText,
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
		)

		eyeButton.translatesAutoresizingMaskIntoConstraints = false
		eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
		eyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
		eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)

		dividerView.translatesAutoresizingMaskIntoConstraints = false
		dividerView.backgroundColor = .separator

		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		errorLabel.textColor = .systemRed
		errorLabel.font = .preferredFont(forTextStyle: .footnote)
		errorLabel.text = "Your Password must meet the requirements below"
		errorLabel.numberOfLines = 0
		errorLabel.lineBreakMode = .byWordWrapping
		errorLabel.isHidden = false
	}

	func layout() {
		addSubview(lockImageView)
		addSubview(textField)
		addSubview(eyeButton)
		addSubview(dividerView)
		addSubview(errorLabel)

		lockImageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
		textField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
		eyeButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)

		NSLayoutConstraint.activate([
			lockImageView.topAnchor.constraint(equalTo: topAnchor),
			lockImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

			textField.topAnchor.constraint(equalTo: topAnchor),
			textField.leadingAnchor.constraint(equalToSystemSpacingAfter: lockImageView.trailingAnchor, multiplier: 1),

			eyeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
			eyeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 1),
			eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor),

			dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
			dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
			dividerView.heightAnchor.constraint(equalToConstant: 1),
			dividerView.topAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),

			errorLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 4),
			errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
	}
}

extension PasswordTextField {
	@objc func togglePasswordView(_ sender: Any) {
		textField.isSecureTextEntry.toggle()
		eyeButton.isSelected.toggle()
	}
}

extension PasswordTextField: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true)
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField) {}

}
