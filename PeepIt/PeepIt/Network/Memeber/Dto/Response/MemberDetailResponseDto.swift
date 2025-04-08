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
    let town: String
    let gender: String
    let profile: String
}

extension MemberDetailResponseDto {

    func toModel() -> UserProfile {
        return .init(
            id: id,
            name: name,
            town: town,
            profile: "",
            gender: GenderType(type: gender),
            isCertificated: role == "CERTIFICATED"
        )
    }
}
