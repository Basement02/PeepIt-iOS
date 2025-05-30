//
//  UserProfile.swift
//  PeepIt
//
//  Created by 김민 on 9/14/24.
//

import Foundation

struct UserInfo: Equatable, Hashable, Codable {
    var id: String = ""
    var nickname: String = ""
    var profileImage: String = ""
    var town: String = ""
    var birth: String?
    var gender: GenderType = .notSelected
    var isAgree: Bool = false
}

extension UserInfo {

    static var stubUser1: UserInfo {
        return .init(
            id: "user1_id",
            nickname: "user1_nickname",
            profileImage: "https://images.unsplash.com/photo-1726268591596-07bb5a41cf75?q=80&w=2350&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            town: "신당동",
            gender: .woman,
            isAgree: false
        )
    }

    static var stubUser2: UserInfo {
        return .init(
            id: "user2_id",
            nickname: "user2_nickname",
            profileImage: "https://images.unsplash.com/photo-1726268591596-07bb5a41cf75?q=80&w=2350&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            town: "화양동",
            gender: .notSelected,
            isAgree: true
        )
    }
}
