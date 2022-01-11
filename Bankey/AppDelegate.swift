//
//  AppDelegate.swift
//  Bankey
//
//  Created by Yash Shah on 06/01/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	let loginViewController = LoginViewController()
	let onboardingContainerViewController = OnboardingContainerViewController()
	let dummyViewController = DummyViewController()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.backgroundColor = .systemBackground

		loginViewController.delegate = self
		onboardingContainerViewController.delegate = self
		dummyViewController.delegate = self

		setRootViewController(loginViewController, animated: false)
		return true
	}
}

extension AppDelegate {
	func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
		guard animated, let window = window else {
			window?.rootViewController = vc
			window?.makeKeyAndVisible()
			return
		}

		window.rootViewController = vc
		window.makeKeyAndVisible()
		UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)

	}
}


extension AppDelegate: LoginViewControllerDelegate {
	func didLogin() {
		if LocalState.hasOnboarded {
			setRootViewController(dummyViewController)
		} else {
			setRootViewController(onboardingContainerViewController)
		}
	}
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
	func didFinishOnboarding() {
		LocalState.hasOnboarded = true
		setRootViewController(dummyViewController)
	}
}

extension AppDelegate: LogOutDelegate {
	func didLogout() {
		setRootViewController(loginViewController)
	}
}
