//
//  MapPeepRequestDto.swift
//  PeepIt
//
//  Created by 김민 on 4/25/25.
//

import Foundation

struct MapPeepRequestDto: Encodable {
    let longitude: Double
    let latitude: Double
    let dist: Int
    let page: Int
    let size: Int
}
