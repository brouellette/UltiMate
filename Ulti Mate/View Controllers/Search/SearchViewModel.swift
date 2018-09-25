//
//  SearchViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

// MARK - Class
final class SearchViewModel {
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
        let annotationViewModel: GameAnnotationViewModel = GameAnnotationViewModel(gameInfo: info)
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
