//
//  Chat.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import Foundation

struct Chat: Equatable, Hashable {
    let id: String
    let user: UserInfo
    let message: String
    let sendTime: String
    let type: ChatType
}

extension Chat {

    static var chatStub1: Chat {
        return .init(
            id: "1",
            user: .stubUser1,
            message: "본문 또는 채팅의 문구입니다.!",
            sendTime: "5분 전",
            type: .others
        )
    }

    static var chatStub2: Chat {
        return .init(
            id: "2",
            user: .stubUser2,
            message: "본문 또는 채팅 문구입니다.본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.",
            sendTime: "5분 전",
            type: .others
        )
    }


    static var chatStub3: Chat {
        return .init(
            id: "3",
            user: .stubUser2,
            message: "본문 또는 채팅의 문구입니다",
            sendTime: "5분 전",
            type: .mine
        )
    }

    static var chatStub4: Chat {
        return .init(
            id: "4",
            user: .stubUser2,
            message: "본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.",
            sendTime: "5분 전",
            type: .uploader
        )
    }

    static var chatStub5: Chat {
        return .init(
            id: "5",
            user: .stubUser1,
            message: "본문 또는 채팅 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.본문 또는 채팅 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.본문 또는 채팅 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.본문 또는 채팅 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.본문 또는 채팅 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.본문 또는 채팅 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.",
            sendTime: "5분 전",
            type: .others
        )
    }

    static var chatStub6: Chat {
        return .init(
            id: "6",
            user: .stubUser1,
            message: "본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.",
            sendTime: "5분 전",
            type: .mine
        )
    }


    static var chatStub7: Chat {
        return .init(
            id: "7",
            user: .stubUser1,
            message: "본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.",
            sendTime: "5분 전",
            type: .mine
        )
    }

    static var chatStub8: Chat {
        return .init(
            id: "8",
            user: .stubUser1,
            message: "본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다. 본문 또는 채팅의 문구입니다.",
            sendTime: "5분 전",
            type: .mine
        )
    }
}
