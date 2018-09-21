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
    var mapView: MKMapView!
        
    var gameViewModels: [GameDetailViewModel] = []
    
    var signedOut: (() -> Void)?
    var gameSelected: ((String) -> Void)?
    
//    private(set) var state: UpdatableProperty<DashboardLayoutState> = UpdatableProperty(value: .map)
    private(set) var menuShowing: UpdatableProperty<Bool> = UpdatableProperty(value: false)
    
    // MARK: Life Cycle
    init() {
        
    }
    
    // MARK: Private
    private func createAnnotation(withDetails details: GameDetails) -> MKPointAnnotation {
        let longitude: Double = Double.random(range: -180...180)
        let latitude: Double = Double.random(range: -90...90)
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = details.title
        annotation.subtitle = details.description
        
        return annotation
    }
    
    // MARK: Public    
    func handleGameDetails(gameDetails: GameDetails) {
        // Create the visual annotation and add it to the map
        let gameAnnotation: MKPointAnnotation = createAnnotation(withDetails: gameDetails)
        mapView.addAnnotation(gameAnnotation)
        
        // Store the gameDetails for future presentation of the game
        let gameDetailViewModel: GameDetailViewModel = GameDetailViewModel(title: gameDetails.title, description: gameDetails.description, competitiveLevel: gameDetails.competitiveLevel)
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
