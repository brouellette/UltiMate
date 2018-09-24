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
    let viewModel: GameAnnotationModel
    
    // MARK: Life Cycle
    init(viewModel: GameAnnotationModel) {
        self.viewModel = viewModel
        
        super.init()
        
        coordinate = CLLocationCoordinate2D(latitude: viewModel.gameInfo.latitude, longitude: viewModel.gameInfo.longitude)
        title = viewModel.gameInfo.title
        subtitle = viewModel.gameInfo.description
    }
}
