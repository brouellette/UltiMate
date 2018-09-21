//
//  UpdatableProperty.swift
//  Aquifer Clinical Learning
//
//  Created by Reid Henderson on 12/20/17.
//  Copyright © 2018 Codeify. All rights reserved.
//

import Foundation

// MARK: - Class
final class UpdatableProperty<T> {
	// MARK: Properties
	typealias Update = (T) -> Void
	private var update: Update?
	
	private var shouldFire: Bool = true
	
	private(set) var value: T {
		didSet {
			if shouldFire {
				update?(value)
			}
		}
	}
	
	// MARK: Life Cycle
	init(value: T) {
		self.value = value
	}
	
	// MARK: Public
	func bind(_ fire: Bool = true, _ update: @escaping Update) {
		self.update = update
		
		if fire {
			self.update?(value)
		}
	}
	
	func unbind() {
		update = nil
	}
	
	func updateValue(_ value: T) {
		self.value = value
	}
	
	func updateWithoutFiring(_ value: T) {
		shouldFire = false
		self.value = value
		shouldFire = true
	}
	
}

// MARK: Extension
extension UpdatableProperty where T: Equatable {
	@discardableResult func updateValueIfNeeded(_ value: T) -> Bool {
		if self.value != value {
			self.value = value
			return true
		}
		
		return false
	}
}
