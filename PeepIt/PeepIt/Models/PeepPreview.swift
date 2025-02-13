//
//  PeepPreview.swift
//  PeepIt
//
//  Created by 김민 on 9/14/24.
//

import Foundation

struct PeepPreview {
    let peepData: String
    let distance: String
    let profile: UserProfile
    let uploadTime: String
    let isHot: Bool
}

extension PeepPreview {

    static var stubPeep1: PeepPreview {
        return .init(
            peepData: "",
            distance: "0.3",
            profile: .stubUser1,
            uploadTime: "5분 전", // TODO: upload time 계산 로직
            isHot: true
        )
    }
}
