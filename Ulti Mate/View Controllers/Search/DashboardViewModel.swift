//
//  DashboardViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

//import MapKit

// MARK: Enum
enum DashboardLayoutState {
    case map
    case table
}

// MARK - Class
final class DashboardViewModel {
    // MARK: Properties
    var gameViewModels: [GameDetailViewModel] = []
    
    var signedOut: (() -> Void)?
    var gameSelected: ((GameInfo) -> Void)?
    
    // MARK: Life Cycle
    init() {
        
    }
    
    // MARK: Private
    
    
    // MARK: Public
    func createAnnotation(withInfo info: GameInfo) -> GameAnnotation {
        let annotationViewModel: GameAnnotationModel = GameAnnotationModel(gameInfo: info)
        let annotation: GameAnnotation = GameAnnotation(viewModel: annotationViewModel)
        
        return annotation
    }
    
    func gameViewModel(forTitle title: String) -> GameDetailViewModel? {
        var foundViewModel: GameDetailViewModel?
        gameViewModels.enumerated().forEach { index, game in
            if game.gameInfo.title == title {
                foundViewModel = gameViewModels[index]
            }
        }
        
        if let viewModel: GameDetailViewModel = foundViewModel {
            return viewModel
        } else {
            return nil
        }
    }
}
