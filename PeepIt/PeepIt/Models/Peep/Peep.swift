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
    var chatNum: Int
    var stickerNum: Int
    let buildingName: String
    let x: Double
    let y: Double
    let popularity: Int
    let profileUrl: String
    let uploadAt: String

    var id: Int { peepId }

    var isMine: Bool {
        writerId == "2"
    }
}

extension Peep {

    static var stubPeep0: Peep {
        return .init(
            peepId: 0,
            data: "https://peepit-prod-bucket.s3.ap-northeast-2.amazonaws.com//peep274f4423-1f71-4324-a038-1fc6bed4624f_스크린샷 2025-04-17 오후 9.17.28.png",
            content: "한 문장은 몇 자까지일까? 어쨋든 말줄임표를 두 문장까지? 문장 끝까지 보이면 안될 것 같지 않아?0",
            writerId: "1",
            isActive: true,
            reaction: "😥",
            isVideo: false,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
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
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }

    static var stubPeep2: Peep {
        return .init(
            peepId: 2,
            data: "",
            content: "본문본문2222kjkjsdlkjalsdkjfasdf",
            writerId: "2",
            isActive: true,
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }

    static var stubPeep3: Peep {
        return .init(
            peepId: 3,
            data: "",
            content: "본문본문3",
            writerId: "2",
            isActive: false,
            isVideo: false,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }

    static var stubPeep4: Peep {
        return .init(
            peepId: 4,
            data: "",
            content: "본문본문4",
            writerId: "2",
            isActive: false,
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }

    static var stubPeep5: Peep {
        return .init(
            peepId: 5,
            data: "",
            content: "본문본문5",
            writerId: "2",
            isActive: false,
            isVideo: false,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }

    static var stubPeep6: Peep {
        return .init(
            peepId: 6,
            data: "",
            content: "본문본문6",
            writerId: "2",
            isActive: true,
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }

    static var stubPeep7: Peep {
        return .init(
            peepId: 7,
            data: "",
            content: "본문본문7",
            writerId: "2",
            isActive: false,
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }

    static var stubPeep8: Peep {
        return .init(
            peepId: 8,
            data: "",
            content: "본문본문8",
            writerId: "2",
            isActive: true,
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
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
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
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
            isVideo: true,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
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
            isVideo: false,
            chatNum: 0,
            stickerNum: 0,
            buildingName: "빌딩 이름",
            x: 127.01583524268014,
            y: 37.564252509725364,
            popularity: 1,
            profileUrl: "",
            uploadAt: "1분 전"
        )
    }
}
