//
//  Untitled.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation

struct CommonPeepDto: Codable {
    let peepId: Int
    let memberId: String
    let town: String
    let imageUrl: String
    let content: String
    let isEdited: Bool
    let profileUrl: String
    let isActive: Bool?
    let uploadAt: String
    let stickerNum: Int
    let chatNum: Int
}

extension CommonPeepDto {

    func toModel() -> Peep {
        return Peep(
            peepId: peepId,
            data: imageUrl,
            content: content,
            writerId: memberId,
            isActive: isActive ?? true, // TODO: - 수정
            reaction: nil, // TODO: - stickerNum 순서 파악 필요
            isVideo: true, // TODO: - isVideo 추가 요청 필요
            chatNum: chatNum
        )
    }
}
