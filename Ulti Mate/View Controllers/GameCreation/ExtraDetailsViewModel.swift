//
//  ExtraDetailsViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import Foundation

// MARK: - Class
final class ExtraDetailsViewModel {
    // MARK: Properties
    private(set) var gameInfo: GameInfo
    
    var continueToReview: (() -> Void)?
    
    // MARK: Life Cycle
    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
    
    // MARK: Public
    func updateCompetitiveLevel(_ index: Int) {
        switch index {
        case 0:
            gameInfo.competitiveLevel = .casual
        case 1:
            gameInfo.competitiveLevel = .semi
        case 2:
            gameInfo.competitiveLevel = .competitive
        default:
            gameInfo.competitiveLevel = .none
        }
    }
    
    func proceed() {
        self.continueToReview?()
    }
}
