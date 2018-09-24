//
//  NamingViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/20/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

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
}

// MARK: - Class
final class NamingViewModel {
    // MARK: Properties
    var title: String = ""
    var description: String = ""
    var playerCount: Int = 0
    var competitiveLevel: CompetitiveLevel = .none
        
    var dismiss: (() -> Void)?
    var continueToMap: (() -> Void)?
    
    // MARK: Life Cycle
    init() {
        
    }
    
    // MARK: Control Handlers
    
    
    // MARK: Private
    
    
    // MARK: Public
    func createGame() {
        let longitude: Double = Double.random(in: -175...175)
        let latitude: Double = Double.random(in: -85...85)
        
        let gameInfo: GameInfo = GameInfo(title: title, description: description, competitiveLevel: competitiveLevel, longitude: longitude, latitude: latitude)
        
        // Save to some kind of database (Firebase?)
        AppCoordinator.gameInfoDatabase.append(gameInfo)
        DLog("Game created and stored successfully!")
    }
}
