//
//  MenuGestureHandlable.swift
//  Proxi
//
//  Created by Reid Henderson on 9/17/16.
//  Copyright © 2018 Codeify LLC. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol MenuGestureHandlable {
	var topmostView: UIView? { get }
	var menuTapAndPanView: UIView { get }
	var menuEdgePan: UIScreenEdgePanGestureRecognizer { get }
	var menuIsClosed: Bool { get }
	var menuIsEnabled: Bool { get set }
	
	func menuButtonHit(_ sender: UIBarButtonItem)
	func menuTapAndPanViewTapped(_ sender: UITapGestureRecognizer)
	func menuTapAndPanViewPanned(_ sender: UIPanGestureRecognizer)
	func menuEdgePanned(_ sender: UIScreenEdgePanGestureRecognizer)
	func toggleMenu()
	func handleMenuPan(_ panRecognizer: UIPanGestureRecognizer)
	func removeTapAndPanView()
}

// MARK: - Extension
extension MenuGestureHandlable where Self: UIViewController {
	fileprivate func parentMenuContainableViewController() -> MenuContainable? {
		// If the UIViewController calling this function has no parent, return nil
		guard let parent = parent else {
			return nil
		}
		
		// If the parent is type MenuContainable, cast it and return
		if let typedParent = parent as? MenuContainable {
			return typedParent
		}
		
		// Traverse the UIViewController hierarchy until a parent of type MenuContainable is found, or until there is no parentViewController
		var currentParent: UIViewController? = parent
		while currentParent != nil {
			let nextParent: UIViewController? = currentParent!.parent
			
			if nextParent is MenuContainable {
				currentParent = nextParent
				break
			}
			
			currentParent = nextParent
		}
		
		// If currentParent exists and is of type MenuContainable, return it, otherwise return nil
		if let typedParent = currentParent as? MenuContainable {
			return typedParent
		} else {
			return nil
		}
	}
	
	var menuIsClosed: Bool {
		guard let menuParent = parentMenuContainableViewController() else  {
			return false
		}
		
		return menuParent.menuClosed
	}
	
	func toggleMenu() {
        guard let menuParent = parentMenuContainableViewController(), menuIsEnabled else  {
            return
        }
		
		menuParent.toggleMenu { [unowned self] menuOpen in
			if menuOpen {
				if let topmostView = self.topmostView {
					self.view.insertSubview(self.menuTapAndPanView, belowSubview: topmostView)
				} else {
					self.view.addSubview(self.menuTapAndPanView)
				}
			} else {
				self.menuTapAndPanView.removeFromSuperview()
			}
		}
	}
	
	func handleMenuPan(_ panRecognizer: UIPanGestureRecognizer) {
		guard let menuParent = parentMenuContainableViewController(), menuIsEnabled else  {
			return
		}
		
		let fromEdge: Bool = panRecognizer is UIScreenEdgePanGestureRecognizer
		
		menuParent.showMenuInteractively(panRecognizer, fromEdge: fromEdge) { [unowned self] menuOpen in
			if menuOpen {
				if let topmostView = self.topmostView {
					self.view.insertSubview(self.menuTapAndPanView, belowSubview: topmostView)
				} else {
					self.view.addSubview(self.menuTapAndPanView)
				}
			} else {
				self.menuTapAndPanView.removeFromSuperview()
			}
		}
	}
	
	func removeTapAndPanView() {
		menuTapAndPanView.removeFromSuperview()
	}
	
}
