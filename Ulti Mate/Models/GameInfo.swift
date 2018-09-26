//
//  GameInfo.swift
//  Ulti Mate
//
//  Created by travis ouellette on 9/21/18.
//  Copyright © 2018 Codeify. All rights reserved.
//

import Foundation

typealias Coordinate = (longitude: Double, latitude:  Double)

// MARK: - Struct
class GameInfo {
    // MARK: Properties
    var title: String = ""
    var description: String = ""
    var competitiveLevel: CompetitiveLevel = .none
    var coordinate: Coordinate = Coordinate(longitude: 0, latitude: 0) // default should be user's location
    var attendingPlayerCount: Int = 0
}
