//
//  Peep.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import Foundation

struct Peep: Equatable, Hashable, Identifiable {
    let peepId: Int
    let data: String
    let content: String
    let writerId: String
    let isActive: Bool
    var reaction: String? = nil
    var isVideo: Bool

    var id: Int { peepId }

    var isMine: Bool {
        writerId == "2"
    }
}

extension Peep {

    static var stubPeep0: Peep {
        return .init(
            peepId: 0,
            data: "",
            content: "한 문장은 몇 자까지일까? 어쨋든 말줄임표를 두 문장까지? 문장 끝까지 보이면 안될 것 같지 않아?0",
            writerId: "1",
            isActive: true,
            reaction: "😥",
            isVideo: false
        )
    }

    static var stubPeep1: Peep {
        return .init(
            peepId: 1,
            data: "",
            content: "본문본문111111111",
            writerId: "1",
            isActive: false,
            reaction: "🤔",
            isVideo: true
        )
    }

    static var stubPeep2: Peep {
        return .init(
            peepId: 2,
            data: "",
            content: "본문본문2222kjkjsdlkjalsdkjfasdf",
            writerId: "2",
            isActive: true,
            isVideo: true
        )
    }

    static var stubPeep3: Peep {
        return .init(
            peepId: 3,
            data: "",
            content: "본문본문3",
            writerId: "2",
            isActive: false,
            isVideo: false
        )
    }

    static var stubPeep4: Peep {
        return .init(
            peepId: 4,
            data: "",
            content: "본문본문4",
            writerId: "2",
            isActive: false,
            isVideo: true
        )
    }

    static var stubPeep5: Peep {
        return .init(
            peepId: 5,
            data: "",
            content: "본문본문5",
            writerId: "2",
            isActive: false,
            isVideo: false
        )
    }

    static var stubPeep6: Peep {
        return .init(
            peepId: 6,
            data: "",
            content: "본문본문6",
            writerId: "2",
            isActive: true,
            isVideo: true
        )
    }

    static var stubPeep7: Peep {
        return .init(
            peepId: 7,
            data: "",
            content: "본문본문7",
            writerId: "2",
            isActive: false,
            isVideo: true
        )
    }

    static var stubPeep8: Peep {
        return .init(
            peepId: 8,
            data: "",
            content: "본문본문8",
            writerId: "2",
            isActive: true,
            isVideo: true
        )
    }

    static var stubPeep9: Peep {
        return .init(
            peepId: 9,
            data: "",
            content: "본문본문9",
            writerId: "2",
            isActive: false,
            reaction: "😭",
            isVideo: true
        )
    }

    static var stubPeep10: Peep {
        return .init(
            peepId: 10,
            data: "",
            content: "본문본문10",
            writerId: "2",
            isActive: false,
            reaction: "😭",
            isVideo: true
        )
    }

    static var stubPeep11: Peep {
        return .init(
            peepId: 11,
            data: "",
            content: "본문본문10",
            writerId: "2",
            isActive: false,
            reaction: "😭",
            isVideo: false
        )
    }
}
