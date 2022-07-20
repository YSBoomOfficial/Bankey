//
//  ViewControllerTests.swift
//  Password Reset BankeyTests
//
//  Created by Yash Shah on 11/05/2022.
//

import XCTest

@testable import Bankey

class ViewControllerTests_NewPassword_Validation: XCTestCase {
	var vc: PasswordResetViewController!
	let validPassword = "12345678Aa!"
	let tooShort = "1234Aa!"

	override func setUp() {
		super.setUp()
		vc = PasswordResetViewController()
	}

	func testEmptyPassword() throws {
		vc.newPasswordText = ""
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "Enter your password")
	}

	func testInvalidPassword() throws {
		vc.newPasswordText = "🕹"
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "Enter valid special chars (.,@:?!()$\\/#) with no spaces")
	}

	func testCriteriaNotMet() throws {
		vc.newPasswordText = tooShort
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "Your password must meet the requirements below")
	}

	func testValidPassword() throws {
		vc.newPasswordText = validPassword
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertEqual(vc.newPasswordTextField.errorLabel.text!, "")
	}

	func testPasswordsDoNotMatch() throws {
		vc.newPasswordText = validPassword
		vc.confirmPasswordText = tooShort
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertEqual(vc.confirmPasswordTextField.errorLabel.text!, "Passwords do not match.")
	}

	func testPasswordsMatch() throws {
		vc.newPasswordText = validPassword
		vc.confirmPasswordText = validPassword
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertEqual(vc.confirmPasswordTextField.errorLabel.text!, "")
	}

}

class ViewControllerTests_Show_Alert: XCTestCase {
	var vc: PasswordResetViewController!
	let validPassword = "12345678Aa!"
	let tooShort = "1234Aa!"

	override func setUp() {
		super.setUp()
		vc = PasswordResetViewController()
	}

	func testShowSuccess() throws {
		vc.newPasswordText = validPassword
		vc.confirmPasswordText = validPassword
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertNotNil(vc.alert)
		XCTAssertEqual(vc.alert!.title, "Success") // Optional
	}

	func testShowError() throws {
		vc.newPasswordText = validPassword
		vc.confirmPasswordText = tooShort
		vc.resetPasswordButtonTapped(sender: UIButton())
		XCTAssertNil(vc.alert)
	}
}
