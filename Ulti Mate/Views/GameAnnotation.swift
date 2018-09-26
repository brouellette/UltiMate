//
//  GameAnnotation.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import MapKit

// MARK: - Class
final class GameAnnotation: MKPointAnnotation {
    // MARK: Properties
    static let Identifier: String = "GameAnnotation"
    let viewModel: GameAnnotationViewModel
    
    // MARK: Life Cycle
    init(viewModel: GameAnnotationViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        coordinate = CLLocationCoordinate2D(latitude: viewModel.gameInfo.coordinate.latitude, longitude: viewModel.gameInfo.coordinate.longitude)
        title = viewModel.gameInfo.title
        subtitle = viewModel.gameInfo.description
    }
}
