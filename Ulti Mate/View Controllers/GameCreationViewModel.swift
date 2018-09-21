//
//  GameCreationViewModel.swift
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
}

// MARK: - Class
final class GameCreationViewModel {
    // MARK: Properties
    var title: String = ""
    var description: String = ""
    var playerCount: Int = 0
    var competitiveLevel: CompetitiveLevel = .none
    
//    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var dismissButtonHit: (() -> Void)?
    var createButtonHit: ((GameDetails) -> Void)?
    
    // MARK: Life Cycle
    init() {
        
    }
    
    // MARK: Control Handlers
    
    
    // MARK: Private
    
    
    // MARK: Public
    func competitiveLevel(from index: Int) {
        switch index {
        case 0:
            competitiveLevel = .casual
        case 1:
            competitiveLevel = .semi
        case 2:
            competitiveLevel = .competitive
        default:
            competitiveLevel = .none
        }
    }
}
