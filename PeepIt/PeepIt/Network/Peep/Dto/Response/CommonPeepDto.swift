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
    let longitude: Double
    let latitude: Double
    let building: String
    let imageUrl: String
    let content: String
    let isEdited: Bool
    let profileUrl: String
    let isActive: Bool
    let uploadAt: String
    let stickerNum: Int
    let chatNum: Int
    let popularity: Int
    let isVideo: Bool
}

extension CommonPeepDto {

    func toModel() -> Peep {
        return Peep(
            peepId: peepId,
            data: imageUrl,
            content: content,
            writerId: memberId,
            isActive: isActive,
            reaction: nil, // TODO: - stickerNum 순서 파악 필요
            isVideo: isVideo,
            chatNum: chatNum,
            stickerNum: stickerNum,
            buildingName: building,
            x: longitude,
            y: latitude,
            popularity: popularity,
            profileUrl: profileUrl,
            uploadAt: uploadAt
        )
    }
}
