//
//  ViewController.swift
//  Bankey
//
//  Created by Yash Shah on 06/01/2022.
//

import UIKit

class LoginViewController: UIViewController {
    let loginView = LoginView()
	let signInButton = UIButton(type: .system)
	let errorMessageLabel = UILabel()

	var username: String? {
		loginView.usernameTextField.text
	}

	var password: String? {
		loginView.passwordTextField.text
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }

}

extension LoginViewController {
    private func style() {
        loginView.translatesAutoresizingMaskIntoConstraints = false

		// signInButton style
		signInButton.translatesAutoresizingMaskIntoConstraints = false
		signInButton.configuration = .filled()
		signInButton.configuration?.imagePadding = 8
		signInButton.setTitle("Sign in", for: [])
		signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)

		// errorMessageLabel style
		errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
		errorMessageLabel.textAlignment = .center
		errorMessageLabel.textColor = .systemRed
		errorMessageLabel.numberOfLines = 0
		errorMessageLabel.isHidden = true
    }

    private func layout() {
        view.addSubview(loginView)
		view.addSubview(signInButton)
		view.addSubview(errorMessageLabel)

        /* multiplier of 1 = 8pts*/
		// LoginView constraints
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1)
        ])

		// signInButton constraints
		NSLayoutConstraint.activate([
			signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
			signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
			signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
		])

			// errorMessageLabel constraints
		NSLayoutConstraint.activate([
			errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
			errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
			errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
		])

    }
}

extension LoginViewController {
	@objc func signInTapped(sender: UIButton) {
		errorMessageLabel.isHidden = true
		login()

	}

	private func login() {
		guard let username = username, let password = password else {
			assertionFailure("`username` and `password` should never be `nil`")
			return
		}

		if username.isEmpty || password.isEmpty {
			configureView(with: "Username/Password cannot be blank")
			return
		}

		if username == "Yash" && password == "Password" {
			signInButton.configuration?.showsActivityIndicator = true


		} else {
			configureView(with: "Incorect Username/Password")
			return
		}

	}

	@MainActor private func configureView(with message: String) {
		errorMessageLabel.isHidden = false
		errorMessageLabel.text = message
	}
}
