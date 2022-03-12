//
//  CurrencyFormatter.swift
//  Bankey
//
//  Created by Yash Shah on 13/01/2022.
//

import UIKit

struct CurrencyFormatter {
	func makeAttributedCurrency(_ amount: Decimal) -> NSMutableAttributedString {
		let tuple = breakIntoParts(amount)
		return makeBalanceAttributed(primary: tuple.0, secondary: tuple.1)
	}

	// Converts 929466 > £929,466.00
	func currencyFormatted(_ primary: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.usesGroupingSeparator = true

		if let result = formatter.string(from: primary as NSNumber) {
			return result
		}

		return ""
	}

	// Converts 929466.23 > "929,466" "23"
	func breakIntoParts(_ amount: Decimal) -> (String, String) {
		let tuple = modf(amount.doubleValue)

		let primary = convertPrimary(tuple.0)
		let secondary = convertSecondary(tuple.1)

		return (primary, secondary)
	}

	// Converts 929466 > 929,466
	private func convertPrimary(_ primaryPart: Double) -> String {
		let currencyWithDecimal = currencyFormatted(primaryPart) // "$929,466.00"

		let decimalSeparator = Locale.current.decimalSeparator ?? "." // "."
		let currencyComponents = currencyWithDecimal.components(separatedBy: decimalSeparator) // "$929,466" "00"

		var primary = currencyComponents.first! // "$929,466"
		primary.removeFirst() // "929,466"

		return primary
	}

	// Convert 0.23 > 23
	private func convertSecondary(_ secondaryPart: Double) -> String {
		let secondary: String
		if secondaryPart == 0 {
			secondary = "00"
		} else {
			secondary = String(format: "%.0f", secondaryPart * 100)
		}

		return secondary
	}

	private func makeBalanceAttributed(primary: String, secondary: String) -> NSMutableAttributedString {
		let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
		let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
		let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]

		let rootString = NSMutableAttributedString(string: Locale.current.currencySymbol ?? "$", attributes: dollarSignAttributes)
		let dollarString = NSAttributedString(string: primary, attributes: dollarAttributes)
		let centString = NSAttributedString(string: secondary, attributes: centAttributes)

		rootString.append(dollarString)
		rootString.append(centString)

		return rootString
	}
}

