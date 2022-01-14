//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Yash Shah on 12/01/2022.
//

import UIKit

class AccountSummaryViewController: UIViewController {
	struct Profile {
		let firstName: String
		let lastName: String
	}

	var header = AccountSummaryHeaderView(frame: .zero)
	var tableView = UITableView()

	lazy var logoutBarButtonItem: UIBarButtonItem = {
		let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
		barButtonItem.tintColor = .label
		return barButtonItem
	}()

	var profile: Profile?
	var accounts = [AccountSummaryCell.ViewModel]()


	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
}

extension AccountSummaryViewController {
	private func setup() {
		setupNavigationBar()
		setupTableView()
		setupTableHeaderView()
		fetchData()
	}

	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self

		tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
		tableView.rowHeight = AccountSummaryCell.rowHeight
		tableView.tableFooterView = UIView()

		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = appColor
		view.addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	private func setupTableHeaderView() {
		var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		size.width = UIScreen.main.bounds.width
		header.frame.size = size

		tableView.tableHeaderView = header
	}

}

// MARK: - UITableViewDataSource
extension AccountSummaryViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard !accounts.isEmpty else { return UITableViewCell() }

		let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
		let account = accounts[indexPath.row]
		cell.configure(with: account)
		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accounts.count
	}
}

// MARK: - UITableViewDelegate
extension AccountSummaryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}

// MARK: - Dummy data
extension AccountSummaryViewController {
	private func fetchData() {
		fetchAccounts()
		fetchProfile()
	}

	// Dummy data
	private func fetchAccounts() {
		let savings = AccountSummaryCell.ViewModel(accountType: .Banking,
												   accountName: "Basic Savings",
												   balance: 929466.23)
		let chequing = AccountSummaryCell.ViewModel(accountType: .Banking,
													accountName: "No-Fee All-In Chequing",
													balance: 17562.44)
		let visa = AccountSummaryCell.ViewModel(accountType: .CreditCard,
												accountName: "Visa Avion Card",
												balance: 412.83)
		let masterCard = AccountSummaryCell.ViewModel(accountType: .CreditCard,
													  accountName: "Student Mastercard",
													  balance: 50.83)
		let investment1 = AccountSummaryCell.ViewModel(accountType: .Investment,
													   accountName: "Tax-Free Saver",
													   balance: 2000.00)
		let investment2 = AccountSummaryCell.ViewModel(accountType: .Investment,
													   accountName: "Growth Fund",
													   balance: 15000.00)

		accounts.append(savings)
		accounts.append(chequing)
		accounts.append(visa)
		accounts.append(masterCard)
		accounts.append(investment1)
		accounts.append(investment2)

	}

	private func fetchProfile() {
		profile = Profile(firstName: "Yash", lastName: "NS_Async_Pain.self")
	}
}

// MARK: - NavBar
extension AccountSummaryViewController {
	func setupNavigationBar() {
		navigationItem.rightBarButtonItem = logoutBarButtonItem
	}

	@objc func logoutTapped(_ sender: UIButton) {
		NotificationCenter.default.post(name: .logout, object: nil)
	}
}
