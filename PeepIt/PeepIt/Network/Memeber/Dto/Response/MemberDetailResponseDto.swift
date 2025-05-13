//
//  MemberDetailResponseDto.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation

struct MemberDetailResponseDto: Decodable {
    let id: String
    let role: String
    let name: String
    let town: String?
    let gender: String
    let profile: String
    let legalCode: String?
    let isAgree: Bool
    let isBlocked: Bool
}

extension MemberDetailResponseDto {

    func toModel() -> UserProfile {
        var townInfo: TownInfo?

        if let town = town, let legalCode = legalCode {
            townInfo = .init(address: town, bCode: legalCode)
        }

        return .init(
            id: id,
            name: name,
            townInfo: townInfo,
            profile: profile,
            gender: GenderType(type: gender),
            isCertificated: role == "CERTIFIED",
            isAgree: isAgree,
            isBlocked: isBlocked
        )
    }
}
