//
//  LocalState.swift
//  Bankey
//
//  Created by Yash Shah on 11/01/2022.
//

import Foundation

public final class LocalState {
	public enum Keys: String {
		case hasOnboarded
	}

	public static var hasOnboarded: Bool {
		get {
			UserDefaults.standard.bool(forKey: Keys.hasOnboarded.rawValue)
		}

		set {
			UserDefaults.standard.set(newValue, forKey: Keys.hasOnboarded.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
}

