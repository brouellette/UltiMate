//
//  PickLocationViewModel.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/24/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

// MARK: - Class
final class PickLocationViewModel {
    // MARK: Properties
    private(set) var gameInfo: GameInfo
    
    var isMapShowing: UpdatableProperty<Bool> = UpdatableProperty(value: false)
    
    var continueToReview: (() -> Void)?
    
    // MARK: Life Cycle
    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
        
        // TODO: Remove this later and use user's current location instead
        let longitude: Double = Double.random(in: -175...175)
        let latitude: Double = Double.random(in: -85...85)
        
        gameInfo.coordinate.longitude = longitude
        gameInfo.coordinate.latitude = latitude
    }
    
    // MARK: Public
    func updateCoordinate(longitude: Double, latitude: Double) {
        gameInfo.coordinate.longitude = longitude
        gameInfo.coordinate.latitude = latitude
    }
    
    func adjustLayout() {
        isMapShowing.updateValue(!isMapShowing.value)
    }
    
    func proceed() {
        continueToReview?()
    }
}
