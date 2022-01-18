//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Yash Shah on 12/01/2022.
//

import UIKit

class AccountSummaryViewController: UIViewController {
	lazy var logoutBarButtonItem: UIBarButtonItem = {
		let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
		barButtonItem.tintColor = .label
		return barButtonItem
	}()

	var profile: Profile?
	var headerView = AccountSummaryHeaderView(frame: .zero)
	var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Hello", name: "Yash", date: Date())

	var tableView = UITableView()
	var accountCellViewModels = [AccountSummaryCell.ViewModel]()
	var accounts = [Account]()

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

	func setup() {
		navigationItem.rightBarButtonItem = logoutBarButtonItem
		setupTableHeaderView()
		setupTableView()

		fetchDataAndLoadViews()
	}
}

// MARK: - Setup
extension AccountSummaryViewController {
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
		var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		size.width = UIScreen.main.bounds.width
		headerView.frame.size = size
		tableView.tableHeaderView = headerView
	}

	@objc func logoutTapped(_ sender: UIButton) {
		NotificationCenter.default.post(name: .logout, object: nil)
	}
}

// MARK: - UITableViewDataSource
extension AccountSummaryViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard !accountCellViewModels.isEmpty else { return UITableViewCell() }

		let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
		let account = accountCellViewModels[indexPath.row]
		cell.configure(with: account)
		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accountCellViewModels.count
	}
}

// MARK: - UITableViewDelegate
extension AccountSummaryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}
}

// MARK: - Networking
extension AccountSummaryViewController {
	private func fetchDataAndLoadViews() {
		let group = DispatchGroup()

		group.enter()
		fetchProfile(forUserId: 1) { result in
			switch result {
				case .success(let profile):
					self.profile = profile
					self.configureTableHeaderView(with: profile)
				case .failure(let error):
					print(error.localizedDescription)
			}
			group.leave()
		}

		group.enter()
		fetchAccounts(forUserId: "1") { result in
			switch result {
				case .success(let accounts):
					self.accounts = accounts
					self.configureTableCells(with: accounts)
				case .failure(let error):
					print(error.localizedDescription)
			}
			group.leave()
		}

		group.notify(queue: .main) { [weak self] in
			self?.tableView.reloadData()
		}
	}

	private func configureTableHeaderView(with profile: Profile) {
		let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,", name: profile.firstName, date: Date())
		headerView.configure(vm: vm)
	}

	private func configureTableCells(with accounts: [Account]) {
		accountCellViewModels = accounts.map {
			AccountSummaryCell.ViewModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
		}
	}
}
