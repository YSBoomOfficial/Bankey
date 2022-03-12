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
//	let passwordCriteriaView = PasswordCriteriaView()
	let reenterPasswordTextField = PasswordTextField(placeholderText: "Re-enter new password")

	override func viewDidLoad() {
		super.viewDidLoad()
		style()
		layout()
	}
}

extension ViewController {
	func style() {
		newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 20
	}

	func layout() {
		stackView.addArrangedSubview(newPasswordTextField)
//		stackView.addArrangedSubview(passwordCriteriaView)
		stackView.addArrangedSubview(reenterPasswordTextField)

		view.addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
			view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
		])
	}
}

