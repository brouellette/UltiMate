//
//  ContainerTransitionable.swift
//  Aquifer Clinical Learning
//
//  Created by Reid Henderson on 12/20/17.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

typealias InteractiveDismissalCompletion = (_ dismissed: Bool) -> Void
typealias TransitionCompletion = () -> Void

// MARK: - Constants
enum TransitionType {
	case fade
	case fromBottom
	case fromRight
	case fromLeft
	case toBottom
}

enum ModalTransitionType {
	case normal
	case fromRight
	case toRight
	
	var animationDuration: TimeInterval {
		return 0.3
	}
	
	func dimView(withFrame frame: CGRect) -> UIView {
		let view = UIView(frame: frame)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		view.alpha = 0.0
		return view
	}
}

// MARK: - Protocol
protocol ContainerTransitionable: ViewControllerContainable {
	var modalDimView: UIView? { get set }
	var nextVisibleViewController: UIViewController? { get }
	var removingVisibleViewController: Bool { get set }
	
	func transitionToViewController(_ viewController: UIViewController, animated: Bool, transitionType type: TransitionType, completion: TransitionCompletion?)
	func removeVisibleViewController(animated: Bool, transitionType type: TransitionType, completion: TransitionCompletion?)
	
	func presentChildModally(_ viewController: UIViewController, animated: Bool, type: ModalTransitionType, completion: TransitionCompletion?)
	func dismissModalChild(animated: Bool, type: ModalTransitionType, completion: TransitionCompletion?)
	
	func dismissModalChildInteractively(_ panRecognizer: UIScreenEdgePanGestureRecognizer, completion: InteractiveDismissalCompletion?)
}

// MARK: - Extensions
fileprivate extension UIViewController {
	private var shadowPath: CGPath {
		let bezierPath: UIBezierPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 0)
		let path: CGPath = bezierPath.cgPath
		return path
	}
	
	private var shadowOpacityForTransition: Float {
		return 0.6
	}
	
	private var shadowRadiusForTransition: CGFloat {
		return 3.0
	}
	
	private var shadowOffsetForTransition: CGSize {
		return CGSize.zero
	}
	
	var showingShadowForTransition: Bool {
		let layer: CALayer = view.layer
		
		guard layer.shadowPath != nil else {
			return false
		}
		
		return layer.shadowOpacity == shadowOpacityForTransition && layer.shadowRadius == shadowRadiusForTransition && layer.shadowOffset == shadowOffsetForTransition
	}
	
	func addShadowForTransition() {
		view.layer.shadowPath = shadowPath
		view.layer.shadowOpacity = shadowOpacityForTransition
		view.layer.shadowRadius = shadowRadiusForTransition
		view.layer.shadowOffset = shadowOffsetForTransition
	}
	
	func removeShadowForTransition() {
		view.layer.shadowPath = nil
		view.layer.shadowOpacity = 0.0
		view.layer.shadowRadius = 3.0								// Default value
		view.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)	// Default value
	}
}

extension ContainerTransitionable where Self: UIViewController {
	// MARK: Private
	fileprivate typealias AnimationValues = (frame: CGRect, alpha: CGFloat, shadow: Bool)
	
	// Returns the child view controller at index childViewControllers.count - 2
	var nextVisibleViewController: UIViewController? {
		// If there is less than or equal to one child view controller, or the root view has less than or equal to one subview, return nil
		if children.count <= 1 || view.subviews.count <= 1 {
			return nil
		}
		
		// Pair childVCs with their view's subview index, sort by subview index, then
		var sortedChildVCs: [UIViewController] = children.map { childVC -> (childVC: UIViewController, subviewIndex: Int) in
			return (childVC: childVC, subviewIndex: view.subviews.index(of: childVC.view)!)
			}.sorted { (childVCSubviewIndex1, childVCSubviewIndex2) -> Bool in
				return childVCSubviewIndex1.subviewIndex < childVCSubviewIndex2.subviewIndex
			}.map { childVCSubviewIndex -> UIViewController in
				return childVCSubviewIndex.childVC
		}
		
		// Remove the last childVC subview index pair as we are looking for the next (directly underneath the visible) VC
		sortedChildVCs.removeLast()
		
		// If there is still a last pair in the array, return the corresponding childVC
		if let nextChildVC: UIViewController = sortedChildVCs.last {
			return nextChildVC
		}
		
		// Otherwise, return nil
		return nil
	}
	
	fileprivate func startAnimationValues(forType type: TransitionType) -> AnimationValues {
		let frame: CGRect
		let alpha: CGFloat
		let shadow: Bool
		
		switch type {
		case .fromBottom:
			frame = CGRect(x: 0.0, y: view.bounds.size.height, width: view.bounds.size.width, height: view.bounds.size.height)
			alpha = 1.0
			shadow = true
		case .fromRight:
			frame = CGRect(x: view.bounds.size.width, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height)
			alpha = 1.0
			shadow = true
		case .fromLeft:
			frame = CGRect(x: -view.bounds.size.width, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height)
			alpha = 1.0
			shadow = true
		case .toBottom:
			frame = view.bounds
			alpha = 1.0
			shadow = true
		default:	// .Fade
			frame = view.bounds
			alpha = 0.0
			shadow = false
		}
		
		return (frame: frame, alpha: alpha, shadow: shadow)
	}
	
	fileprivate func endAnimationValues(forType type: TransitionType) -> AnimationValues {
		let frame: CGRect
		let alpha: CGFloat
		let shadow: Bool
		
		switch type {
		case .fromBottom:
			frame = view.bounds
			alpha = 1.0
			shadow = true
		case .fromRight:
			frame = view.bounds
			alpha = 1.0
			shadow = true
		case .fromLeft:
			frame = view.bounds
			alpha = 1.0
			shadow = true
		case .toBottom:
			frame = CGRect(x: 0.0, y: view.bounds.size.height, width: view.bounds.size.width, height: view.bounds.size.height)
			alpha = 1.0
			shadow = true
		default:	// .Fade
			frame = view.bounds
			alpha = 1.0
			shadow = false
		}
		
		return (frame: frame, alpha: alpha, shadow: shadow)
	}
	
	fileprivate func animateTransition(type: TransitionType, viewController: UIViewController, completion: TransitionCompletion?) {
		let startValues = startAnimationValues(forType: type)
		let endValues = endAnimationValues(forType: type)
		
		animateTransition(from: startValues, to: endValues, duration: 0.3, viewController: viewController, completion: completion)
	}
	
	fileprivate func animateTransition(from: AnimationValues, to: AnimationValues, duration: TimeInterval, viewController: UIViewController, completion: TransitionCompletion?) {
		viewController.view.frame = from.frame
		viewController.view.alpha = from.alpha
		
		if from.shadow {
			viewController.addShadowForTransition()
		}
		
		UIView.animate(withDuration: duration, animations: {
			self.setNeedsStatusBarAppearanceUpdate()
			viewController.view.frame = to.frame
			viewController.view.alpha = to.alpha
		}, completion: { (finished) in
			if to.shadow {
				viewController.removeShadowForTransition()
			}
			
			completion?()
		})
	}
	
	// MARK: Public
	func transitionToViewController(_ viewController: UIViewController, animated: Bool, transitionType type: TransitionType = .fade, completion: TransitionCompletion?) {
		// If there is no visible view controller, set the visible view controller and return
		guard let visible = visibleViewController else {
			setVisibleViewController(viewController, callAppearanceFunctions: true)
			return
		}
		
		// Disable user interaction on the visible VC
		visible.view.isUserInteractionEnabled = false
		
		visible.willMove(toParent: nil)
		addChild(viewController)
		
		visible.beginAppearanceTransition(false, animated: animated)
		viewController.beginAppearanceTransition(true, animated: animated)
		
		let startValues = startAnimationValues(forType: type)
		let endValues = endAnimationValues(forType: type)
		
		viewController.view.frame = startValues.frame
		viewController.view.alpha = startValues.alpha
		
		view.addSubview(viewController.view)
		
		if startValues.shadow {
			viewController.addShadowForTransition()
		}
		
		func finishTransition() {
			// Re-enable user interaction on what was the visible VC
			visible.view.isUserInteractionEnabled = true
			visible.view.removeFromSuperview()
			
			if endValues.shadow {
				viewController.removeShadowForTransition()
			}
			
			visible.endAppearanceTransition()
			viewController.endAppearanceTransition()
			
			visible.removeFromParent()
			viewController.didMove(toParent: self)
			
			completion?()
		}
		
		if animated {
			animateTransition(type: type, viewController: viewController, completion: {
				finishTransition()
			})
		} else {
			setNeedsStatusBarAppearanceUpdate()
			finishTransition()
		}
	}
	
	func removeVisibleViewController(animated: Bool, transitionType type: TransitionType = .toBottom, completion: TransitionCompletion?) {
		guard let visible = visibleViewController else {
			print("Unable to dismiss visible view controller, as there isn't one!")
			return
		}
		
		removingVisibleViewController = true
		
		// Disable user interaction on the visible VC
		visible.view.isUserInteractionEnabled = false
		
		let nextVisible: UIViewController? = nextVisibleViewController
		
		visible.willMove(toParent: nil)
		visible.beginAppearanceTransition(false, animated: animated)
		nextVisible?.beginAppearanceTransition(true, animated: animated)
		
		func finishTransition() {
			// Re-enable user interaction on what was the visible VC
			visible.view.isUserInteractionEnabled = true
			visible.view.removeFromSuperview()
			
			visible.endAppearanceTransition()
			nextVisible?.endAppearanceTransition()
			
			visible.removeFromParent()
			
			removingVisibleViewController = false
			completion?()
		}
		
		if animated {
			animateTransition(type: type, viewController: visible) {
				finishTransition()
			}
		} else {
			setNeedsStatusBarAppearanceUpdate()
			finishTransition()
		}
	}
	
	func presentChildModally(_ viewController: UIViewController, animated: Bool, type: ModalTransitionType, completion: TransitionCompletion?) {
		// If there is no visible view controller, set the visible view controller and return
		guard let visible = visibleViewController else {
			setVisibleViewController(viewController, callAppearanceFunctions: true)
			return
		}
		
		// Disable user interaction on the visible VC
		visible.view.isUserInteractionEnabled = false
		
		addChild(viewController)
		
		switch type {
		case .normal:
			viewController.view.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
			viewController.addShadowForTransition()
		case .fromRight:
			viewController.view.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
			viewController.addShadowForTransition()
		case .toRight:
			fatalError("Presenting a child view controller modally with type \"toRight\" is not allowed.")
		}
		
		// Add viewController's view
		view.addSubview(viewController.view)
		
		visible.beginAppearanceTransition(false, animated: animated)
		viewController.beginAppearanceTransition(true, animated: animated)
		
		// Finish transition function
		func finishTransition() {
			// Re-enable user interaction on what was the visible VC
			visible.view.isUserInteractionEnabled = true
			visible.endAppearanceTransition()
			
			if viewController.showingShadowForTransition {
				viewController.removeShadowForTransition()
			}
			
			if animated {
				viewController.endAppearanceTransition()
			}
			viewController.didMove(toParent: self)
			
			completion?()
		}
		
		// Perform animations
		let duration: TimeInterval = animated ? type.animationDuration : 0
		
		switch type {
		case .normal:
			UIView.animate(withDuration: duration, animations: {
				self.setNeedsStatusBarAppearanceUpdate()
				viewController.view.frame = self.view.bounds
			}, completion: { finished in
				finishTransition()
			})
		case .fromRight:
			UIView.animate(withDuration: duration, animations: {
				self.setNeedsStatusBarAppearanceUpdate()
				viewController.view.frame = self.view.bounds
			}, completion: { finished in
				finishTransition()
			})
		case .toRight:
			fatalError("Presenting a child view controller modally with type \"toRight\" is not allowed.")
		}
	}
	
	func dismissModalChild(animated: Bool, type: ModalTransitionType, completion: TransitionCompletion?) {
		// If there is no visible view controller, set the visible view controller and return
		guard let visible = visibleViewController else {
			print("Unable to dismiss modal view controller, as there isn't one!")
			return
		}
		
		removingVisibleViewController = true
		
		// Disable user interaction on the visible VC
		visible.view.isUserInteractionEnabled = false
		
		let nextVisible: UIViewController? = nextVisibleViewController
		
		visible.willMove(toParent: nil)
		visible.beginAppearanceTransition(false, animated: animated)
		nextVisible?.beginAppearanceTransition(true, animated: animated)
		
		// Finish transition function
		func finishTransition() {
			// Re-enable user interaction on what was the visible VC
			visible.view.isUserInteractionEnabled = true
			
			visible.view.removeFromSuperview()
			visible.endAppearanceTransition()
			nextVisible?.endAppearanceTransition()
			
			visible.removeFromParent()
			
			removingVisibleViewController = false
			completion?()
		}
		
		// Perform animations
		let duration: TimeInterval = animated ? type.animationDuration : 0
		
		switch type {
		case .normal:
			visible.addShadowForTransition()
			
			UIView.animate(withDuration: duration, animations: {
				self.setNeedsStatusBarAppearanceUpdate()
				visible.view.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
			}, completion: { finished in
				finishTransition()
			})
		case .toRight:
			visible.addShadowForTransition()
			
			UIView.animate(withDuration: duration, animations: {
				self.setNeedsStatusBarAppearanceUpdate()
				visible.view.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
			}, completion: { finished in
				finishTransition()
			})
		case .fromRight:
			fatalError("Dismissing a child view controller modally with type \"fromRight\" is not allowed.")
		}
	}
	
	func dismissModalChildInteractively(_ panRecognizer: UIScreenEdgePanGestureRecognizer, completion: InteractiveDismissalCompletion?)  {
		guard let visible = visibleViewController else {
			return
		}
		
		let defaultDuration: CGFloat = 0.3
		
		let maxTranslation: CGFloat = view.bounds.width
		let translation: CGFloat = panRecognizer.translation(in: view).x
		
		let velocity: CGFloat = panRecognizer.velocity(in: view).x
		let percentComplete: CGFloat = max(0, min(translation / maxTranslation, 1))
		
		let newFrame: CGRect = CGRect(x: maxTranslation * percentComplete, y: 0, width: view.bounds.width, height: view.bounds.height)
		
		switch panRecognizer.state {
		case .began:
			visible.addShadowForTransition()
		case .changed:
			visible.view.frame = newFrame
		case .ended, .cancelled, .failed:
			if velocity > 0 {	// Dismissing
				visible.willMove(toParent: nil)
				visible.beginAppearanceTransition(false, animated: true)
				
				let nextVisible: UIViewController? = nextVisibleViewController
				nextVisible?.beginAppearanceTransition(true, animated: true)
				
				let duration: TimeInterval = Double(min(abs((maxTranslation - newFrame.origin.x) / velocity), CGFloat(defaultDuration)))
				let from: AnimationValues = (frame: visible.view.frame, alpha: 1.0, shadow: false)
				let to: AnimationValues = (frame: CGRect(x: maxTranslation, y: 0, width: maxTranslation, height: view.bounds.height), alpha: 1.0, shadow: false)
				
				animateTransition(from: from, to: to, duration: duration, viewController: visible, completion: {
					visible.view.removeFromSuperview()
					visible.endAppearanceTransition()
					nextVisible?.endAppearanceTransition()
					visible.removeFromParent()
					completion?(true)
				})
				
			} else if velocity < 0 {  // Not Dismissing
				let duration: TimeInterval = Double(min(abs(newFrame.origin.x / velocity), CGFloat(defaultDuration)))
				let from: AnimationValues = (frame: visible.view.frame, alpha: 1.0, shadow: false)
				let to: AnimationValues = (frame: CGRect(x: 0, y: 0, width: maxTranslation, height: view.bounds.height), alpha: 1.0, shadow: false)
				
				animateTransition(from: from, to: to, duration: duration, viewController: visible, completion: {
					completion?(false)
				})
			} else {	// 0 Velocity (released without any horizontal movement)
				// Dismissing
				if percentComplete >= 0.5 {
					visible.willMove(toParent: nil)
					visible.beginAppearanceTransition(false, animated: true)
					
					let nextVisible: UIViewController? = nextVisibleViewController
					nextVisible?.beginAppearanceTransition(true, animated: true)
					
					let duration: TimeInterval = Double(min(abs((maxTranslation - newFrame.origin.x) / velocity), CGFloat(defaultDuration)))
					let from: AnimationValues = (frame: visible.view.frame, alpha: 1.0, shadow: false)
					let to: AnimationValues = (frame: CGRect(x: maxTranslation, y: 0, width: maxTranslation, height: view.bounds.height), alpha: 1.0, shadow: false)
					
					animateTransition(from: from, to: to, duration: duration, viewController: visible, completion: {
						visible.view.removeFromSuperview()
						visible.endAppearanceTransition()
						
						nextVisible?.endAppearanceTransition()
						visible.removeFromParent()
						completion?(true)
					})
					
				} else { // Not Dismissing
					let duration: TimeInterval = Double(min(abs(newFrame.origin.x / velocity), CGFloat(defaultDuration)))
					let from: AnimationValues = (frame: visible.view.frame, alpha: 1.0, shadow: false)
					let to: AnimationValues = (frame: CGRect(x: 0, y: 0, width: maxTranslation, height: view.bounds.height), alpha: 1.0, shadow: false)
					
					animateTransition(from: from, to: to, duration: duration, viewController: visible, completion: {
						completion?(false)
					})
				}
			}
		default:
			print("Do nothing")
		}
	}
	
}
