//
//  DummyViewController.swift
//  Bankey
//
//  Created by Yash Shah on 11/01/2022.
//

import UIKit

class DummyViewController: UIViewController {
	let stackView = UIStackView()
	let label = UILabel()
	let logoutButton = UIButton(type: .system)

	weak var delegate: LogOutDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		style()
		layout()
	}
}

extension DummyViewController {
	private func style() {
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 20

		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Would you like to logout?"
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .title1)

		logoutButton.translatesAutoresizingMaskIntoConstraints = false
		logoutButton.configuration = .filled()
		logoutButton.setTitle("Log Out", for: [])
		logoutButton.addTarget(self, action: #selector(logOutTapped), for: .primaryActionTriggered)

	}

	private func layout() {
		stackView.addArrangedSubview(label)
		stackView.addArrangedSubview(logoutButton)

		view.addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}

	@objc func logOutTapped(_ sender: UIButton) {
		delegate?.didLogout()
	}

}
