//
//  PageRequestDto.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation

struct PageRequestDto: Encodable {
    var page: Int = 0
    var size: Int = 10
}

struct PageAndIdRequestDto: Encodable {
    var memberId: String
    var page: Int = 0
    var size: Int = 10
}
