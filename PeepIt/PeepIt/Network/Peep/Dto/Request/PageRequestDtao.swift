//
//  PageRequestDto.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation

struct PageRequestDto: Encodable {
    let page: Int = 0
    let size: Int = 10
}

struct PageAndIdRequestDto: Encodable {
    let memberId: String
    let page: Int = 0
    let size: Int = 10
}
