//
//  Location.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation

struct TownInfo: Equatable, Codable {
    let address: String
    let bCode: String
}

struct Coordinate: Equatable {
    let x: Double
    let y: Double
}
