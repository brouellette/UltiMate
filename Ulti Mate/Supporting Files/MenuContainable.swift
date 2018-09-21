//
//  MenuContainable.swift
//  Proxi
//
//  Created by Reid Henderson on 9/17/16.
//  Copyright © 2018 Codeify LLC. All rights reserved.
//

import UIKit

// MARK: Typealias
typealias MenuAnimationCompletion = (_ menuOpen: Bool) -> ()

// MARK: - Protocol
protocol MenuContainable: ViewControllerContainable {
	var menuViewController: MenuViewController { get }
	var menuClosed: Bool { get }
	
	func toggleMenu(_ completion: MenuAnimationCompletion?)
	func showMenuInteractively(_ panRecognizer: UIPanGestureRecognizer, fromEdge: Bool, completion: MenuAnimationCompletion?)
}

// MARK: - Extension
extension MenuContainable where Self: UIViewController {
	fileprivate var defaultDuration: TimeInterval {
		return 0.25
	}
	
	fileprivate var menuWidthMultiplier: CGFloat {
		return 0.8
	}
	
	fileprivate var showingMenu: Bool {
		guard let visible = visibleViewController else {
			return false
		}
		
		return visible.view.frame.origin.x == (view.bounds.width * menuWidthMultiplier)
	}
	
	fileprivate var menuClosedFrame: CGRect {
		return view.bounds
	}
	
	fileprivate var menuOpenFrame: CGRect {
		return CGRect(x: view.bounds.width * menuWidthMultiplier, y: 0, width: view.bounds.width, height: view.bounds.height)
	}
	
	fileprivate func openMenu(_ duration: TimeInterval, curve: UIViewAnimationCurve = .easeInOut, completion: MenuAnimationCompletion?) {
		guard let visible = visibleViewController else {
			return
		}
		
		visible.view.addShadowForTransition()
		
		let options = UIViewAnimationOptions(rawValue: UInt(curve.rawValue << 16))
		
		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			visible.view.frame = self.menuOpenFrame
		}) { (finished) in
			completion?(true)
		}
	}
	
	fileprivate func closeMenu(_ duration: TimeInterval, curve: UIViewAnimationCurve = .easeInOut, completion: MenuAnimationCompletion?) {
		guard let visible = visibleViewController else {
			return
		}
		
		let options = UIViewAnimationOptions(rawValue: UInt(curve.rawValue << 16))
		
		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			visible.view.frame = self.menuClosedFrame
		}) { (finished) in
			visible.view.removeShadowForTransition()
			completion?(false)
		}
	}
		
	var menuClosed: Bool {
		guard let visible = visibleViewController else {
			return false
		}
		
		return visible.view.frame.origin.x == menuClosedFrame.origin.x
	}
	
	func toggleMenu(_ completion: MenuAnimationCompletion?) {
		if showingMenu {
			closeMenu(defaultDuration, completion: completion)
		} else {
			openMenu(defaultDuration, completion: completion)
		}
	}
	
	func showMenuInteractively(_ panRecognizer: UIPanGestureRecognizer, fromEdge: Bool, completion: MenuAnimationCompletion?) {
		guard let visible = visibleViewController else {
			return
		}
		
		let maxTranslation: CGFloat = menuOpenFrame.origin.x
		var translation: CGFloat = panRecognizer.translation(in: view).x
		
		if !fromEdge {
			translation = maxTranslation + translation
		}
		
		let velocity: CGFloat = panRecognizer.velocity(in: view).x
		let percentComplete: CGFloat = max(0, min(translation / maxTranslation, 1))
		
		let newFrame: CGRect = CGRect(x: maxTranslation * percentComplete, y: 0, width: view.bounds.width, height: view.bounds.height)
		
		switch panRecognizer.state {
		case .began:
			visible.view.addShadowForTransition()
		case .changed:
			visible.view.frame = newFrame
		case .ended, .cancelled, .failed:
			// Opening
			if velocity > 0 {
				let duration: TimeInterval = Double(min(abs((maxTranslation - newFrame.origin.x) / velocity), CGFloat(defaultDuration)))
				openMenu(duration, curve: .easeOut, completion: completion)
			} else if velocity < 0 {  // Closing
				let duration: TimeInterval = Double(min(abs(newFrame.origin.x / velocity), CGFloat(defaultDuration)))
				closeMenu(duration, curve: .easeOut, completion: completion)
			} else {	// 0 Velocity (released without any horizontal movement)
				// Opening
				if percentComplete >= 0.5 {
					let duration: TimeInterval = Double(min(abs((maxTranslation - newFrame.origin.x) / velocity), CGFloat(defaultDuration)))
					openMenu(duration, completion: completion)
				} else { // Closing
					let duration: TimeInterval = Double(min(abs(newFrame.origin.x / velocity), CGFloat(defaultDuration)))
					closeMenu(duration, completion: completion)
				}
			}
		default:
			DLog("Do nothing")
		}
	}
	
}
