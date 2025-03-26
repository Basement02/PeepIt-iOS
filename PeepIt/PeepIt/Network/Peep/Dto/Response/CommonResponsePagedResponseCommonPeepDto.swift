//
//  PagedResponsePeepDto.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation

struct PagedResponsePeepDto: Decodable {
    let content: [CommonPeepDto]
    let page: Int
    let size: Int
    let totalPages: Int
    let totalElements: Int
    let hasNext: Bool
}

extension PagedResponsePeepDto {

    func toModel() -> [Peep] {
        return content.map { $0.toModel() }
    }
}
