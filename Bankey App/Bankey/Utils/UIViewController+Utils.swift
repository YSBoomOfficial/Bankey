//
//  UIViewController+Utils.swift
//  Bankey
//
//  Created by Yash Shah on 12/01/2022.
//

import UIKit

extension UIViewController {
	func setStatusBar() {
		let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
		guard let statusBarSize = scene?.statusBarManager?.statusBarFrame.size else { fatalError("setStatusBar failed") }

		let frame = CGRect(origin: .zero, size: statusBarSize)
		let statusBarView = UIView(frame: frame)

		statusBarView.backgroundColor = appColor
		view.addSubview(statusBarView)
	}

	func setTabBarImage(imageName: String, title: String) {
		let configuration = UIImage.SymbolConfiguration(scale: .large)
		let image = UIImage(systemName: imageName, withConfiguration: configuration)
		tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
	}


}
