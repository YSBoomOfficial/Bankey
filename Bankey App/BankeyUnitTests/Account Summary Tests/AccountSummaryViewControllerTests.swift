//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by Yash Shah on 19/01/2022.
//

import Foundation
import XCTest
@testable import Bankey

class MockProfileManager: ProfileManageable {
	var profile: Profile?
	var error: NetworkError?

	func fetchProfile(forUserId userId: Int, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
		if error != nil {
			completion(.failure(error!))
			return
		}
		profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
		completion(.success(profile!))
	}
}

class MockAccountsManager: AccountsManageable {
	var accounts = [Account]()
	var error: NetworkError?

	func fetchAccounts(forUserId userId: Int, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
		if error != nil {
			completion(.failure(error!))
			return
		}

		accounts.append(Account.makeSkeleton())
		completion(.success(accounts))
	}
}

class AccountSummaryViewControllerTests: XCTestCase {
	var vc: AccountSummaryViewController!
	var mockProfileManager: MockProfileManager!
	var mockAccountsManager: MockAccountsManager!

	override func setUp() {
		super.setUp()
		vc = AccountSummaryViewController()
		// vc.loadViewIfNeeded()

		mockProfileManager = MockProfileManager()
		vc.profileManager = mockProfileManager

		mockAccountsManager = MockAccountsManager()
		vc.accountsManager = mockAccountsManager
	}

	func testTitleAndMessageForDecodingError() throws {
		mockAccountsManager.error = NetworkError.decodingError
		vc.forceFetchAccounts()

		let title = "Decoding Error"
		let message = "Could not process your request. Please try again later."
		XCTAssertEqual(title, vc.errorAlert.title)
		XCTAssertEqual(message, vc.errorAlert.message)
	}

	func testTitleAndMessageForServerError() throws {
		mockProfileManager.error = NetworkError.serverError
		vc.forceFetchProfile()

		let title = "Server Error"
		let message = "Could not fetch data. Ensure you are connected to the internet. Please try again later."
		XCTAssertEqual(title, vc.errorAlert.title)
		XCTAssertEqual(message, vc.errorAlert.message)
	}
}
