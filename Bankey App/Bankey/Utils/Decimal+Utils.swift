//
//  Decimal+Utils.swift
//  Bankey
//
//  Created by Yash Shah on 13/01/2022.
//

import Foundation

extension Decimal {
	var doubleValue: Double {
		return NSDecimalNumber(decimal: self).doubleValue
	}
}
