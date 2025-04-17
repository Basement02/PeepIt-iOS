//
//  MyActivityPeep.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import Foundation

struct ReactedPeep: Equatable, Hashable {
    let data: String
    let reaction: String
    let distance: String
    let isActivate: Bool
}

extension ReactedPeep {

    static var reactPeepStub: ReactedPeep {
        return .init(
            data: "",
            reaction: "", 
            distance: "0.3",
            isActivate: false
        )
    }
}


struct CommentedPeep: Equatable, Hashable {
    let data: String
    let distance: String
    let isActivate: Bool
}

extension CommentedPeep {

    static var commentPeepStub: CommentedPeep {
        return .init(
            data: "",
            distance: "0.4",
            isActivate: true
        )
    }
}
