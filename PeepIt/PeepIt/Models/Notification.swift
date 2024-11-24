//
//  Notification.swift
//  PeepIt
//
//  Created by 김민 on 11/25/24.
//

import Foundation

struct Notification: Equatable {
    let id: Int
    let title: String
    let content: String
    let date: String
}

extension Notification {

    static var stubNoti0: Notification {
        Notification(
            id: 0,
            title: "내 핍에 n개의 새로운 댓글이 달렸어요.",
            content: "아이디: “댓글 내용”, 아이디: “댓글 내용”아이디: “댓글 내용”, 아이디: “댓글 내용”",
            date: "3분 전"
        )
    }

    static var stubNoti1: Notification {
        Notification(
            id: 1,
            title: "{아이디1}님이 내 핍에 반응을 남겼어요.",
            content: "",
            date: "3분 전"
        )
    }
}
