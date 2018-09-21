//
//  ViewControllerContainable.swift
//  Aquifer Clinical Learning
//
//  Created by Reid Henderson on 12/20/17.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol ViewControllerContainable: NSObjectProtocol {
	var visibleViewController: UIViewController? { get }
	
	func setVisibleViewController(_ viewController: UIViewController, callAppearanceFunctions: Bool)
}

// MARK: Extension
extension ViewControllerContainable where Self: UIViewController {
	var visibleViewController: UIViewController? {
		// If there are no child view controllers, or the root view has no subviews, return nil
		if childViewControllers.count == 0 || view.subviews.count == 0 {
			return nil
		}
		
		// Iterate through all the child view controllers, keeping track of the subview index
		var topmostChildVC: UIViewController? = nil
		var currentTopmostSubviewIndex: Int = -1
		childViewControllers.forEach { childVC in
			guard let subviewIndex = view.subviews.index(of: childVC.view) else {
				return
			}
			
			// If the subviewIndex is greater than the currentTopmostSubviewIndex, update currentTopmostSubviewIndex and set topmostChildVC
			if subviewIndex > currentTopmostSubviewIndex {
				currentTopmostSubviewIndex = subviewIndex
				topmostChildVC = childVC
			}
		}
		
		// If we have found a topmostChildVC, return it
		if let visibleChild = topmostChildVC {
			return visibleChild
		}
		
		return nil
	}
	
	func setVisibleViewController(_ viewController: UIViewController, callAppearanceFunctions: Bool) {
        let alreadyHasVisible: Bool = visibleViewController != nil
		
		addChildViewController(viewController)
		
		if callAppearanceFunctions {
			viewController.beginAppearanceTransition(true, animated: false)
		}
		
		viewController.view.frame = view.bounds
		view.addSubview(viewController.view)
		
		if callAppearanceFunctions && alreadyHasVisible {
			viewController.endAppearanceTransition()
		}
		
		viewController.didMove(toParentViewController: self)
		setNeedsStatusBarAppearanceUpdate()
	}
	
}
