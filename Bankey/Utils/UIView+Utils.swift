//
//  UIView+Utils.swift
//  Bankey
//
//  Created by Yash Shah on 15/01/2022.
//

import UIKit

// MARK: Code Snippet from: https://www.hackingwithswift.com/example-code/calayer/how-to-change-a-views-anchor-point-without-moving-it
extension UIView {
	func setAnchorPoint(_ point: CGPoint) {
		var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
		var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

		newPoint = newPoint.applying(transform)
		oldPoint = oldPoint.applying(transform)

		var position = layer.position

		position.x -= oldPoint.x
		position.x += newPoint.x

		position.y -= oldPoint.y
		position.y += newPoint.y

		layer.position = position
		layer.anchorPoint = point
	}
}
