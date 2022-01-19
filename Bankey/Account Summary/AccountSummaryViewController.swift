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

	let refreshControl = UIRefreshControl()

	var isLoaded = false

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = logoutBarButtonItem
		setupTableView()
		setupTableHeaderView()
		setupRefreshControl()
		setupSkeletons()
		fetchData()
	}
}

// MARK: - Setup
extension AccountSummaryViewController {
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self

		tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
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
		let account = accountCellViewModels[indexPath.row]

		if isLoaded {
			let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
			cell.configure(with: account)
			return cell
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accountCellViewModels.count
	}
}

// MARK: - UITableViewDelegate
extension AccountSummaryViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

// MARK: - Networking
extension AccountSummaryViewController {
	private func fetchData() {
		let group = DispatchGroup()

		group.enter()
		fetchProfile(forUserId: 1) { result in
			switch result {
				case .success(let profile):
					self.profile = profile
					self.configureTableHeaderView(with: profile)
				case .failure(let error):
					self.displayError(error: error)
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
					self.displayError(error: error)
			}
			group.leave()
		}

		group.notify(queue: .main) {
			self.tableView.refreshControl?.endRefreshing()

			guard let profile = self.profile else { return }

			self.isLoaded = true
			self.configureTableHeaderView(with: profile)
			self.configureTableCells(with: self.accounts)
			self.tableView.reloadData()
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

	private func displayError(error: NetworkError) {
		let title: String
		let message: String
		switch error {
			case .serverError:
				title = "Server Error"
				message = "Could not fetch data. Ensure you are connected to the internet. \(error.localizedDescription). Please try again later."
			case .decodingError:
				title = "Decoding Error"
				message = "Could not process your request. \(error.localizedDescription). Please try again later."
		}
		showErrorAlert(with: title, message: message)
	}

	private func showErrorAlert(with title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

}

// MARK: - Pull-to-Refresh + Skeleton Loader
extension AccountSummaryViewController {
	private func setupRefreshControl() {
		refreshControl.tintColor = appColor
		refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
		tableView.refreshControl = refreshControl
	}

	@objc private func refreshContent(_ sender: UIRefreshControl) {
		reset()
		setupSkeletons()
		tableView.reloadData()
		fetchData()
	}

	private func reset() {
		profile = nil
		accounts = []
		isLoaded = false
	}

	private func setupSkeletons() {
		let row = Account.makeSkeleton()
		accounts = Array(repeating: row, count: 10)
		configureTableCells(with: accounts)
	}
}
