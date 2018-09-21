//
//  RootViewController.swift
//  Aquifer Clinical Learning
//
//  Created by Reid Henderson on 12/20/17.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: - Class
final class RootViewController: UIViewController, ContainerTransitionable {
	// MARK: Properties
	var modalDimView: UIView?
	var removingVisibleViewController: Bool = false
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		guard let visibleChild: UIViewController = visibleViewController else {
			return .default
		}
		
		return visibleChild.preferredStatusBarStyle
	}
	
	override var shouldAutomaticallyForwardAppearanceMethods: Bool {
		return false
	}
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		visibleViewController?.beginAppearanceTransition(true, animated: animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		visibleViewController?.endAppearanceTransition()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		visibleViewController?.beginAppearanceTransition(false, animated: animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		visibleViewController?.endAppearanceTransition()
	}
}
