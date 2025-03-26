//
//  MapPeepRequest.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation

struct MapPeepRequest: Encodable {
    let dist: Int = 5
    let page: Int = 0
    let size: Int = 10
    let latitude: Double
    let longitude: Double
}
