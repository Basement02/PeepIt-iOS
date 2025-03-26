//
//  PagedPeeps.swift
//  PeepIt
//
//  Created by 김민 on 3/26/25.
//

import Foundation

struct PagedPeeps {
    let content: [Peep]
    var page: Int
    var size: Int
    var totalPages: Int
    var totalElements: Int
    var hasNext: Bool
}
