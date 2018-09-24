//
//  GameDetailViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

// MARK - Class
final class GameDetailViewModel {
    // MARK: Properties
    var gameInfo: GameInfo
    
    var dismissButtonHit: (() -> Void)?
    
    var competitiveIndex: Int {
        switch gameInfo.competitiveLevel {
        case .casual?:
            return 0
        case .semi?:
            return 1
        case .competitive?:
            return 2
        default:
            return -1
        }
    }
    
    // MARK: Life Cycle
    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
    
    deinit {
        print("GameDetailViewModel deallocated")
    }
    
    // MARK: Public
    
}
