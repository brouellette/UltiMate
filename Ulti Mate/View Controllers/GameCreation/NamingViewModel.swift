//
//  NamingViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/20/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import UIKit

// MARK: Enum
enum CompetitiveLevel {
    case casual
    case semi
    case competitive
    case none
    
    init(index: Int) {
        switch index {
        case 0:
            self = .casual
        case 1:
            self = .semi
        case 2:
            self = .competitive
        default:
            self = .none
        }
    }
    
    var index: Int {
        switch self {
        case .casual:
            return 0
        case .semi:
            return 1
        case .competitive:
            return 2
        case .none:
            return UISegmentedControl.noSegment
        }
    }
}

// MARK: - Class
final class NamingViewModel {
    // MARK: Properties    
    private(set) var gameInfo: GameInfo
        
    var dismiss: (() -> Void)?
    var continueToMap: (() -> Void)?
    
    // MARK: Life Cycle
    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
    
    // MARK: Control Handlers
    
    
    // MARK: Private
    
    
    // MARK: Public
    func updateTitle(_ title: String) {
        self.gameInfo.title = title
    }
    
    func updateDescription(_ description: String) {
        self.gameInfo.description = description
    }
    
    func proceed() {
        continueToMap?()
    }
}
