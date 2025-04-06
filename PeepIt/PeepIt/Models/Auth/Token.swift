//
//  Untitled.swift
//  PeepIt
//
//  Created by 김민 on 4/7/25.
//

import Foundation

struct Token {
    var registerToken: String
    var accessToken: String
    var refreshToken: String
}

extension Token {
    var isNewMember: Bool {
        !registerToken.isEmpty
    }
}
