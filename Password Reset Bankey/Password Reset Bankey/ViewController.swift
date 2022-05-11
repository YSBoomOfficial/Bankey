//
//  ViewController.swift
//  Password Reset Bankey
//
//  Created by Yash Shah on 12/03/2022.
//

import UIKit

class ViewController: UIViewController {
	let stackView = UIStackView()

	let newPasswordTextField = PasswordTextField(placeholderText: "New password")
	let statusView = PasswordStatusView()
	let reenterPasswordTextField = PasswordTextField(placeholderText: "Re-enter new password")
	let resetButton = UIButton(type: .system)

	override func viewDidLoad() {
		super.viewDidLoad()
		style()
		layout()
	}
}

extension ViewController {
	func style() {
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 20

		newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
		newPasswordTextField.delegate = self

		statusView.translatesAutoresizingMaskIntoConstraints = false
		statusView.layer.cornerRadius = 5
		statusView.clipsToBounds = true

		reenterPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
		reenterPasswordTextField.delegate = self

		resetButton.translatesAutoresizingMaskIntoConstraints = false
		resetButton.configuration = .filled()
		resetButton.setTitle("Reset password", for: [])
		resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .primaryActionTriggered)

	}

	func layout() {
		stackView.addArrangedSubview(newPasswordTextField)
		stackView.addArrangedSubview(statusView)
		stackView.addArrangedSubview(reenterPasswordTextField)

		view.addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
			view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
		])
	}

	@objc func resetPasswordButtonTapped(sender: UIButton) {

	}
}

// MARK: PasswordTextFieldDelegate
extension ViewController: PasswordTextFieldDelegate {
	func editingChanged(_ sender: PasswordTextField) {
		if sender === newPasswordTextField {
			statusView.updateDisplay(sender.textField.text ?? "")
		}
	}
}
