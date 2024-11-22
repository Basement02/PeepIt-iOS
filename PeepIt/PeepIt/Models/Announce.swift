//
//  Announce.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import Foundation

struct Announce: Identifiable, Equatable {
    let id: Int
    let category: String
    let title: String
    let content: String
    let date: String
    let image: String?
}

extension Announce {

    static var announce1: Announce {
        return .init(
            id: 0,
            category: "분류",
            title: "공지 제목이 여기서 시작됩니다.",
            content: "본문이겠죠? 서비스 내용입니다. 엄청 길어져도 자름 그야 글이 길면 못생겼기 때문입니다. 공지는 무엇이 있을까요?본문이겠죠? 서비스 내용입니다. 엄청 길어져도 자름 그야 글이 길면 못생겼기 때문입니다. 공지는 무엇이 있을까요?본문이겠죠? 서비스 내용입니다. 엄청 길어져도 자름 그야 글이 길면 못생겼기 때문입니다. 공지는 무엇이 있을까요?본문이겠죠? 서비스 내용입니다. 엄청 길어져도 자름 그야 글이 길면 못생겼기 때문입니다. 공지는 무엇이 있을까요?본문이겠죠? 서비스 내용입니다. 엄청 길어져도 자름 그야 글이 길면 못생겼기 때문입니다. 공지는 무엇이 있을까요?본문이겠죠? 서비스 내용입니다. 엄청 길어져도 자름 그야 글이 길면 못생겼기 때문입니다. 공지는 무엇이 있을까요?본문이겠죠? 서비스 내용입니다. 엄청 길어져도 자름 그야 글이 길면 못생겼기 때문입니다. 공지는 무엇이 있을까요?",
            date: "3월 19일",
            image: nil
        )
    }

    static var announce2: Announce {
        return .init(
            id: 1,
            category: "분류",
            title: "공지 제목",
            content: "본문이겠죠?!",
            date: "3월 19일",
            image: nil
        )
    }
}
