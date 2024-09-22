//
//  Chat.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import Foundation

struct Chat {
    let user: UserProfile
    let message: String
    let sendTime: String
    let type: ChatType
}

extension Chat {

    static var chatStub1: Chat {
        return .init(
            user: .stubUser1,
            message: "안녕하세요!",
            sendTime: "5분 전",
            type: .others
        )
    }

    static var chatStub2: Chat {
        return .init(
            user: .stubUser2,
            message: "안녕하세요!",
            sendTime: "5분 전",
            type: .mine
        )
    }
}
