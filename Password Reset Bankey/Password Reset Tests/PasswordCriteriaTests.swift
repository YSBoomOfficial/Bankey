//
//  PasswordCriteriaTests.swift
//  Password Reset BankeyTests
//
//  Created by Yash Shah on 11/05/2022.
//

import XCTest

@testable import Bankey

class PasswordLengthCriteriaTests: XCTestCase {
	func testLong() throws {
		XCTAssertFalse(PasswordCriteria.lengthCriteriaMet("123456789012345678901234567890123"))
	}

	func testValidShort() throws {
		XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("12345678"))
	}

	func testValidLong() throws {
		XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("12345678901234567890123456789012"))
	}
}

class PasswordOtherCriteriaTests: XCTestCase {
	func testSpaceMet() throws {
		XCTAssertTrue(PasswordCriteria.noSpaceCriteriaMet("abc"))
	}

	func testSpaceNotMet() throws {
		XCTAssertFalse(PasswordCriteria.noSpaceCriteriaMet("a bc"))
	}

	func testLengthAndNoSpaceMet() throws {
		XCTAssertTrue(PasswordCriteria.lengthAndNoSpaceMet("12345678"))
	}

	func testLengthAndNoSpaceNotMet() throws {
		XCTAssertFalse(PasswordCriteria.lengthAndNoSpaceMet("1234567 8"))
	}

	func testUpperCaseMet() throws {
		XCTAssertTrue(PasswordCriteria.uppercaseMet("A"))
	}

	func testUpperCaseNotMet() throws {
		XCTAssertFalse(PasswordCriteria.uppercaseMet("a"))
	}

	func testLowerCaseMet() throws {
		XCTAssertTrue(PasswordCriteria.lowercaseMet("a"))
	}

	func testLowerCaseNotMet() throws {
		XCTAssertFalse(PasswordCriteria.lowercaseMet("A"))
	}

	func testDigitMet() throws {
		XCTAssertTrue(PasswordCriteria.digitMet("1"))
	}

	func testDigitNotMet() throws {
		XCTAssertFalse(PasswordCriteria.digitMet("a"))
	}

	func testSpecicalCharMet() throws {
		XCTAssertTrue(PasswordCriteria.specialCharacterMet("@"))
	}

	func testSpecicalCharNotMet() throws {
		XCTAssertFalse(PasswordCriteria.specialCharacterMet("a"))
	}
}
