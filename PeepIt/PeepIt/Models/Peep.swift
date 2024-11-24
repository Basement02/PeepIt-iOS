//
//  Peep.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import Foundation

struct Peep: Equatable, Hashable, Identifiable {
    let peepId: Int
    let image: String
    let content: String
    let writerId: String
    let isActive: Bool

    var id: Int { peepId }
}

extension Peep {

    static var stubPeep0: Peep {
        return .init(
            peepId: 0,
            image: "",
            content: "본문본문0",
            writerId: "1",
            isActive: true
        )
    }

    static var stubPeep1: Peep {
        return .init(
            peepId: 1,
            image: "",
            content: "본문본문1",
            writerId: "1",
            isActive: false
        )
    }

    static var stubPeep2: Peep {
        return .init(
            peepId: 2,
            image: "",
            content: "본문본문2",
            writerId: "2",
            isActive: true
        )
    }

    static var stubPeep3: Peep {
        return .init(
            peepId: 3,
            image: "",
            content: "본문본문3",
            writerId: "2",
            isActive: false
        )
    }
}
