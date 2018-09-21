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
    var title: String
    var description: String
    var competitiveLevel: CompetitiveLevel
    var longitude: Double
    var latitude: Double
    
    var dismissButtonHit: (() -> Void)?
    
    var competitiveIndex: Int {
        switch competitiveLevel {
        case .casual:
            return 0
        case .semi:
            return 1
        case .competitive:
            return 2
        default:
            return -1
        }
    }
    
    // MARK: Life Cycle
    init(title: String, description: String, competitiveLevel: CompetitiveLevel, longitude: Double, latitude: Double) {
        self.title = title
        self.description = description
        self.competitiveLevel = competitiveLevel
        self.longitude = longitude
        self.latitude = latitude
    }
    
    deinit {
        print("GameDetailViewModel deallocated")
    }
    
    // MARK: Public
    
}
