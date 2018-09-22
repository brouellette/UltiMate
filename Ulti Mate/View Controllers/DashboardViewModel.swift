//
//  DashboardViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/1/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import MapKit

// MARK: Enum
enum DashboardLayoutState {
    case map
    case table
}

// MARK - Class
final class DashboardViewModel {
    // MARK: Properties
//    var mapView: MKMapView!
    
    var gameViewModels: [GameDetailViewModel] = []
    
    var signedOut: (() -> Void)?
    var gameSelected: ((String) -> Void)?
    var gameAdded: ((GameInfo) -> Void)?
        
    // MARK: Life Cycle
    init() {
        
    }
    
    // MARK: Private
    
    
    // MARK: Public
    func createAnnotation(withInfo info: GameInfo) -> MKPointAnnotation {
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = info.title
        annotation.subtitle = info.description
        
        return annotation
    }
    
    func handleGameInfo(gameInfo: GameInfo) {
        // Create the visual annotation and add it to the map, then scroll to it
        gameAdded?(gameInfo)

        // Store the gameDetails for future presentation of the game
        let gameDetailViewModel: GameDetailViewModel = GameDetailViewModel(title: gameInfo.title, description: gameInfo.description, competitiveLevel: gameInfo.competitiveLevel, longitude: gameInfo.longitude, latitude: gameInfo.latitude)

        self.gameViewModels.append(gameDetailViewModel)
    }
    
    func gameViewModel(forTitle title: String) -> GameDetailViewModel? {
        var foundViewModel: GameDetailViewModel?
        gameViewModels.enumerated().forEach { index, game in
            if game.title == title {
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
