//
//  Utils.swift
//  Aquifer Clinical Learning
//
//  Created by Reid Henderson on 12/20/17.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit
import CoreData

// MARK: Functions
func DLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
	#if DEBUG
		let dateFormatter: DateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm:ss.SSS"
		
		let date: Date = Date()
		let time: String = dateFormatter.string(from: date)
		
		var fileName: String = file
		let fileURL: NSURL = NSURL(fileURLWithPath: file)
		
		if let fileNameWithExtension: String = fileURL.lastPathComponent {
			fileName = fileNameWithExtension.components(separatedBy: ".")[0]
		}
		
		var thread: String
		if Thread.isMainThread {
			thread = "main"
		} else {
			thread = "background"
		}
		
		print("\(time): \(thread) - \(fileName).\(function) (\(line)):\n\(message)\n")
	#endif
}

// Object deinit
private let DILogEnabled = false
func DILog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
	if !DILogEnabled {
		return
	}
	
	DLog(message, file: file, function: function, line: line)
}

// Sync
private let DSLogEnabled = false
func DSLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
	if !DSLogEnabled {
		return
	}
	
	DLog(message, file: file, function: function, line: line)
}

// MARK: Structs
struct AppAppearance {
    static let UltiMateOrange: UIColor = UIColor(r: 244, g: 96, b: 54, alpha: 1)
    static let UltiMateLightBlue: UIColor = UIColor(r: 91, g: 133, b: 170, alpha: 1)
    static let UltiMateDarkBlue: UIColor = UIColor(r: 65, g: 71, b: 112, alpha: 1)
}

// MARK: Enums
enum SyncFrequency {
	case once
	case periodically(timeInterval: TimeInterval)
}

enum ContentState {
	case loaded
	case loading
	case empty
}

// MARK: Extensions
extension UIApplication {
	static var interfaceIdiomIsPad: Bool {
		return UI_USER_INTERFACE_IDIOM() == .pad
	}
	
	class func optimizeImage(for image: UIImage) -> UIImage {
		let imageSize: CGSize = image.size
		UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0)
		image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
		let optimizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return optimizedImage
	}
}

extension Sequence where Self.Element: AnyObject {
	public func containsObjectIdentical(to object: AnyObject) -> Bool {
		return contains { $0 === object }
	}
}

extension UIViewController {
	var interfaceIdiomIsPad: Bool {
		return UIApplication.interfaceIdiomIsPad
	}
}

extension UINavigationController {
	override open var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

extension UIView {
	func addConstraintsWithFormat(format: String, views: UIView...) {
		var viewsDictionary: [String: UIView] = [:]
		for (index, view) in views.enumerated() {
			let key: String = "v\(index)"
			viewsDictionary[key] = view
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewsDictionary))
	}
    
    private var shadowPath: CGPath {
        let bezierPath: UIBezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
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
    
    func addShadowForTransition() {
        layer.shadowPath = shadowPath
        layer.shadowOpacity = shadowOpacityForTransition
        layer.shadowRadius = shadowRadiusForTransition
        layer.shadowOffset = shadowOffsetForTransition
    }
    
    func removeShadowForTransition() {
        layer.shadowPath = nil
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 3.0                    // Default value
        layer.shadowOffset = CGSize(width: 0.0, height: -3.0)    // Default value
    }
	
	/// Addes required constraints with the provided insets from the callee to its superview
	///
	/// - Parameter insets: Values for right and bottom should be negative for proper inset
	func pinEdgesToSuperview(insets: UIEdgeInsets = .zero) {
		guard let superview: UIView = self.superview else {
			return
		}
		
		leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
		trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right).isActive = true
		topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
		bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom).isActive = true
	}
}

extension UIImage {
	static func optimizeImageForScrolling(image: UIImage) -> UIImage {
		let imageSize: CGSize = image.size
		UIGraphicsBeginImageContextWithOptions(imageSize, true, 1)
		image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
		let optimizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return optimizedImage
	}
}

extension Double {
    static func random(range: CountableClosedRange<Int> ) -> Double {
        var offset = 0
        
        if range.lowerBound < 0 {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound + offset)
        
        return Double(mini + arc4random_uniform(maxi - mini)) - Double(offset)
    }
}

extension UITextView {
	static func makeWithNoPadding(andBackgroundColor backgroundColor: UIColor, editable: Bool = false, scrollEnabled: Bool = false) -> UITextView {
		let textView: UITextView = UITextView()
		textView.backgroundColor = backgroundColor
		textView.isEditable = editable
		textView.isScrollEnabled = scrollEnabled
		textView.dataDetectorTypes = [.link]
		textView.textContainerInset = .zero
		textView.textContainer.lineFragmentPadding = 0
		textView.subviews.forEach { $0.backgroundColor = backgroundColor }
		
		return textView
	}
	
	func forceBackgroundColor(_ color: UIColor) {
		backgroundColor = color
		subviews.forEach { $0.backgroundColor = color }
	}
}

extension UIColor {
	convenience init(r: Int, g: Int, b: Int, alpha: CGFloat) {
		self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
	}
	
	var r: Int {
		var red: CGFloat = 0
		getRed(&red, green: nil, blue: nil, alpha: nil)
		return Int(red * 255)
	}
	
	var g: Int {
		var green: CGFloat = 0
		getRed(nil, green: &green, blue: nil, alpha: nil)
		return Int(green * 255)
	}
	
	var b: Int {
		var blue: CGFloat = 0
		getRed(nil, green: nil, blue: &blue, alpha: nil)
		return Int(blue * 255)
	}
	
}

extension Notification.Name {

}

// MARK: Functions
