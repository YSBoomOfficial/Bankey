//
//  AccountSummaryCell.swift
//  Bankey
//
//  Created by Yash Shah on 13/01/2022.
//

import UIKit

class AccountSummaryCell: UITableViewCell {
	static let reuseID = "AccountSummaryCell"
	static let rowHeight: CGFloat = 112

	let viewModel: ViewModel? = nil

	let typeLabel = UILabel()
	let underlineView = UIView()
	let nameLabel = UILabel()

	let balanceStackView = UIStackView()
	let balanceLabel = UILabel()
	let balanceAmountLabel = UILabel()

	let chevronImageView = UIImageView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
		layout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension AccountSummaryCell {
	private func setup() {
		// TypeLabel
		typeLabel.translatesAutoresizingMaskIntoConstraints = false
		typeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
		typeLabel.adjustsFontForContentSizeCategory = true
		typeLabel.text = "Account Type"

		// Underline View
		underlineView.translatesAutoresizingMaskIntoConstraints = false
		underlineView.backgroundColor = appColor

		// Name Label
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
		nameLabel.adjustsFontForContentSizeCategory = true
		nameLabel.text = "Account Name"

		// Balance Stack View
		balanceStackView.translatesAutoresizingMaskIntoConstraints = false
		balanceStackView.axis = .vertical
		balanceStackView.spacing = 0

		// Balance Label
		balanceLabel.translatesAutoresizingMaskIntoConstraints = false
		balanceLabel.font = UIFont.preferredFont(forTextStyle: .body)
		balanceLabel.adjustsFontForContentSizeCategory = true
		balanceLabel.textAlignment = .right
		balanceLabel.text = "Some Balance"

		// Balance Amount Label
		balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
		balanceAmountLabel.font = UIFont.preferredFont(forTextStyle: .body)
		balanceAmountLabel.adjustsFontForContentSizeCategory = true
		balanceAmountLabel.textAlignment = .right
		balanceAmountLabel.attributedText = makeFormattedBalance(primary: "929,466", secondary: "23")

		// Chevron Image View
		chevronImageView.translatesAutoresizingMaskIntoConstraints = false
		chevronImageView.contentMode = .scaleAspectFit
		chevronImageView.image = UIImage(systemName: "chevron.right")!.withTintColor(appColor, renderingMode: .alwaysOriginal)
	}

	private func layout() {
		/// `contentView.addSubview()` for `UITableViewCell` **NOT** `view.addSubview()`
		contentView.addSubview(typeLabel)
		contentView.addSubview(underlineView)
		contentView.addSubview(nameLabel)

		balanceStackView.addArrangedSubview(balanceLabel)
		balanceStackView.addArrangedSubview(balanceAmountLabel)

		contentView.addSubview(balanceStackView)
		contentView.addSubview(chevronImageView)

		// TypeLabel
		NSLayoutConstraint.activate([
			typeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
		])

		// Underline View
		NSLayoutConstraint.activate([
			underlineView.topAnchor.constraint(equalToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1),
			underlineView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
			underlineView.widthAnchor.constraint(equalToConstant: 60),
			underlineView.heightAnchor.constraint(equalToConstant: 4)
		])

		// Name Label
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 2),
			nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
		])

		// Balance Stack View
		NSLayoutConstraint.activate([
			balanceStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
			balanceStackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
			trailingAnchor.constraint(equalToSystemSpacingAfter: balanceStackView.trailingAnchor, multiplier: 4)
		])

		// Chevron Image View
		NSLayoutConstraint.activate([
			chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			trailingAnchor.constraint(equalToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 1)
		])

	}
}

extension AccountSummaryCell {
	private func makeFormattedBalance(primary: String, secondary: String) -> NSMutableAttributedString {
		let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
		let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
		let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset: 8]

		let rootString = NSMutableAttributedString(string: Locale.current.currencySymbol ?? "$", attributes: dollarSignAttributes)
		let dollarString = NSAttributedString(string: primary, attributes: dollarAttributes)
		let centString = NSAttributedString(string: secondary, attributes: centAttributes)

		rootString.append(dollarString)
		rootString.append(centString)

		return rootString
	}
}

extension AccountSummaryCell {
	enum AccountType: String {
		case Banking, CreditCard, Investment
	}

	struct ViewModel {
		let accountType: AccountType
		let accountName: String
		let balance: Decimal

		var balanceAsAttributedString: NSAttributedString {
			CurrencyFormatter().makeAttributedCurrency(balance)
		}
	}

	func configure(with vm: ViewModel) {
		typeLabel.text = vm.accountType.rawValue
		nameLabel.text = vm.accountName
		balanceLabel.attributedText = vm.balanceAsAttributedString

		switch vm.accountType {
			case .Banking:
				underlineView.backgroundColor = appColor
				balanceLabel.text = "Current Balance"
			case .CreditCard:
				underlineView.backgroundColor = .systemOrange
				balanceLabel.text = "Current Balance"
			case .Investment:
				underlineView.backgroundColor = .systemPurple
				balanceLabel.text = "Value"
		}

	}

}
