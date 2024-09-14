//
//  UserProfile.swift
//  PeepIt
//
//  Created by 김민 on 9/14/24.
//

import Foundation

struct UserProfile {
    let profileImage: String
    let id: String
}

extension UserProfile {

    static var stubUser1: UserProfile {
        return .init(
            profileImage: "https://images.unsplash.com/photo-1726268591596-07bb5a41cf75?q=80&w=2350&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            id: "user1"
        )
    }
}
