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

    func toModel() -> PagedPeeps {
        return .init(
            content: content.map { $0.toModel() },
            page: page,
            size: size,
            totalPages: totalPages,
            totalElements: totalElements,
            hasNext: hasNext
        )
    }
}
