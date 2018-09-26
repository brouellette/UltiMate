//
//  ReviewViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

// MARK: - Class
final class ReviewViewModel {
    // MARK: Properties
    private(set) var gameInfo: GameInfo
    
    var finish: (() -> Void)?
    
    // MARK: Life Cycle
    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
}
