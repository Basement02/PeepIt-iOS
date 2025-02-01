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
    var reaction: String? = nil

    var id: Int { peepId }

    var isMine: Bool {
        writerId == "2"
    }
}

extension Peep {

    static var stubPeep0: Peep {
        return .init(
            peepId: 0,
            image: "",
            content: "본문본문0",
            writerId: "1",
            isActive: true,
            reaction: "😥"
        )
    }

    static var stubPeep1: Peep {
        return .init(
            peepId: 1,
            image: "",
            content: "본문본문1",
            writerId: "1",
            isActive: false,
            reaction: "🤔"
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

    static var stubPeep4: Peep {
        return .init(
            peepId: 4,
            image: "",
            content: "본문본문4",
            writerId: "2",
            isActive: false
        )
    }

    static var stubPeep5: Peep {
        return .init(
            peepId: 5,
            image: "",
            content: "본문본문5",
            writerId: "2",
            isActive: false
        )
    }

    static var stubPeep6: Peep {
        return .init(
            peepId: 6,
            image: "",
            content: "본문본문6",
            writerId: "2",
            isActive: true 
        )
    }

    static var stubPeep7: Peep {
        return .init(
            peepId: 7,
            image: "",
            content: "본문본문7",
            writerId: "2",
            isActive: false
        )
    }

    static var stubPeep8: Peep {
        return .init(
            peepId: 8,
            image: "",
            content: "본문본문8",
            writerId: "2",
            isActive: true
        )
    }

    static var stubPeep9: Peep {
        return .init(
            peepId: 9,
            image: "",
            content: "본문본문9",
            writerId: "2",
            isActive: false,
            reaction: "😭"
        )
    }

    static var stubPeep10: Peep {
        return .init(
            peepId: 10,
            image: "",
            content: "본문본문10",
            writerId: "2",
            isActive: false,
            reaction: "😭"
        )
    }

    static var stubPeep11: Peep {
        return .init(
            peepId: 11,
            image: "",
            content: "본문본문10",
            writerId: "2",
            isActive: false,
            reaction: "😭"
        )
    }
}
