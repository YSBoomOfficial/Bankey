//
//  ViewController.swift
//  Bankey
//
//  Created by Yash Shah on 06/01/2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
	func didLogin()
}

class LoginViewController: UIViewController {
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()

	let loginView = LoginView()
	let signInButton = UIButton(type: .system)

	let passwordResetButton = UIButton(type: .system)

	let errorMessageLabel = UILabel()

	weak var delegate: LoginViewControllerDelegate?

	var username: String? {
		loginView.usernameTextField.text
	}

	var password: String? {
		loginView.passwordTextField.text
	}

	var leadingEdgeOnScreen: CGFloat = 16
	var leadingEdgeOffScreen: CGFloat = -1000

	var titleLeadingAnchor: NSLayoutConstraint?
	var subtitleLeadingAnchor: NSLayoutConstraint?

	override func viewDidLoad() {
		super.viewDidLoad()
		style()
		layout()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		signInButton.configuration?.showsActivityIndicator = false
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animate()
	}

}

extension LoginViewController {
	private func style() {
		// titleLabel style
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textAlignment = .center
		titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		titleLabel.adjustsFontForContentSizeCategory = true
		titleLabel.text = "Bankey"
		titleLabel.alpha = 0

		// subtitleLabel style
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		subtitleLabel.textAlignment = .center
		subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
		subtitleLabel.adjustsFontForContentSizeCategory = true
		subtitleLabel.numberOfLines = 0
		subtitleLabel.text = "Your premium source for all things banking!"
		subtitleLabel.alpha = 0

		loginView.translatesAutoresizingMaskIntoConstraints = false

		// signInButton style
		signInButton.translatesAutoresizingMaskIntoConstraints = false
		signInButton.configuration = .filled()
		signInButton.configuration?.imagePadding = 8
		signInButton.setTitle("Sign in", for: [])
		signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)

		// passwordResetButton style
		passwordResetButton.translatesAutoresizingMaskIntoConstraints = false
		passwordResetButton.configuration = .plain()
		passwordResetButton.configuration?.imagePadding = 8
		passwordResetButton.setTitle("Forgot Password?", for: [])
		passwordResetButton.addTarget(self, action: #selector(passwordResetTapped), for: .primaryActionTriggered)

		// errorMessageLabel style
		errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
		errorMessageLabel.textAlignment = .center
		errorMessageLabel.textColor = .systemRed
		errorMessageLabel.numberOfLines = 0
		errorMessageLabel.isHidden = true
	}

	private func layout() {
		view.addSubview(titleLabel)
		view.addSubview(subtitleLabel)
		view.addSubview(loginView)
		view.addSubview(signInButton)
		view.addSubview(passwordResetButton)
		view.addSubview(errorMessageLabel)

		/* multiplier of 1 = 8pts*/

		// titleLabel constraints
		NSLayoutConstraint.activate([
			subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
			titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
		])

		titleLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
		titleLeadingAnchor?.isActive = true

		// subtitleLabel constraints
		NSLayoutConstraint.activate([
			loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
			subtitleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
		])

		subtitleLeadingAnchor = subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
		subtitleLeadingAnchor?.isActive = true

		// LoginView constraints
		NSLayoutConstraint.activate([
			loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
			view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1),
		])

		// signInButton constraints
		NSLayoutConstraint.activate([
			signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
			signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
			signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
		])

		// passwordResetButton constraints
		NSLayoutConstraint.activate([
			passwordResetButton.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
			passwordResetButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
			passwordResetButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
		])

		// errorMessageLabel constraints
		NSLayoutConstraint.activate([
			errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: passwordResetButton.bottomAnchor, multiplier: 2),
			errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
			errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
		])



	}
}

extension LoginViewController {
	@objc func signInTapped(_ sender: UIButton) {
		errorMessageLabel.isHidden = true
		login()
	}

	@objc func passwordResetTapped(_ sender: UIButton) {
		print("passwordResetTapped")
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

		if username == "Yash" && password == "Pass" {
			signInButton.configuration?.showsActivityIndicator = true
			delegate?.didLogin()
			loginView.usernameTextField.text = ""
			loginView.passwordTextField.text = ""
		} else {
			configureView(with: "Incorrect Username/Password")
			return
		}
	}

	private func configureView(with message: String) {
		errorMessageLabel.isHidden = false
		errorMessageLabel.text = message
		shakeButton()
	}
}

// MARK: - Animation
extension LoginViewController {
	private func animate() {
		let duration = 0.8

		let animator1 = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
			self.titleLeadingAnchor?.constant = self.leadingEdgeOnScreen
			self.view.layoutIfNeeded()
		}
		animator1.startAnimation()

		let animator2 = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
			self.subtitleLeadingAnchor?.constant = self.leadingEdgeOnScreen
			self.view.layoutIfNeeded()
		}
		animator2.startAnimation(afterDelay: 0.2)

		let animator3 = UIViewPropertyAnimator(duration: duration*2 , curve: .easeInOut) {
			self.titleLabel.alpha = 1
			self.subtitleLabel.alpha = 1
			self.view.layoutIfNeeded()
		}
		animator3.startAnimation(afterDelay: 0.2)
	}

	private func shakeButton() {
		let animation = CAKeyframeAnimation()
		animation.keyPath = "position.x"
		animation.values = [0, 20, -20, 10, -10, 5, -5, 0]
		animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.175, 0.625, 1]
		animation.duration = 0.5

		animation.isAdditive = true
		signInButton.layer.add(animation, forKey: "shake")
	}

}
