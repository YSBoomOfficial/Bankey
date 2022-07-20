//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by Yash Shah on 14/01/2022.
//

import Foundation
import XCTest

@testable import Bankey

class CurrencyFormatterTests: XCTestCase {
	var formatter: CurrencyFormatter!

	override func setUp() {
		super.setUp()
		formatter = CurrencyFormatter()
	}

	func testBreakIntoParts() throws {
		let result = formatter.breakIntoParts(18630.27)
		XCTAssertEqual(result.0, "18,630")
		XCTAssertEqual(result.1, "27")
	}

	func testCurrencyFormatted() throws {
		let pounds = formatter.currencyFormatted(929466)
		XCTAssertEqual(pounds, "\(Locale.current.currencySymbol!)929,466.00")
	}

	func testZeroCurrencyFormatted() throws {
		let pounds = formatter.currencyFormatted(0)
		XCTAssertEqual(pounds, "\(Locale.current.currencySymbol!)0.00")
	}

}
