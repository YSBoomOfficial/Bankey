//
//  ViewController.swift
//  TextField Inline interactions Sandbox
//
//  Created by Yash Shah on 11/05/2022.
//

import UIKit

class ViewController: UIViewController {
	let textField = UITextField()

	override func viewDidLoad() {
		super.viewDidLoad()
		style()
		layout()
	}
}

extension ViewController {
	private func style() {
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "New password"
		textField.backgroundColor = .systemGray6
		textField.borderStyle = .roundedRect
		textField.delegate = self

		// extra interaction
		textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
	}

	private func layout() {
		view.addSubview(textField)

		NSLayoutConstraint.activate([
			textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			textField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
			view.trailingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 2)
		])
	}
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {

	// return `false` to disallow editing.
	// called when textfield comes into focus or when editing has begun
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return true
	}

	// became first responder
	func textFieldDidBeginEditing(_ textField: UITextField) {}

	// return `true` to allow editing to stop and to resign first responder status.
	// return `false` to disallow the editing session to end
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}

	// if implemented, called in place of textFieldDidEndEditing
	func textFieldDidEndEditing(_ textField: UITextField) {}

	// detect - keypress
	// return `false` to not change text
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let word = textField.text ?? ""
		let char = string
		print("Default - shouldChangeCharactersIn: '\(word)' '\(char)'")
		return true
	}

	// Custom method for `.editingChanged` control event
	@objc func textFieldEditingChanged(_ sender: UITextField) {
		print("Extra - textFieldEditingChanged: '\(sender.text ?? "")'")
	}

	// called when 'clear' button pressed. return `false` to ignore (no notifications)
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return true
	}

	// called when 'return' key pressed. return `false` to ignore.
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true) // resign first responder `textField.resignFirstResponder()`
		return true
	}
	
}

