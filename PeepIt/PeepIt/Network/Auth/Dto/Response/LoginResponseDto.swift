//
//  LoginResponseDto.swift
//  PeepIt
//
//  Created by 김민 on 4/7/25.
//

import Foundation

struct LoginResponseDto: Decodable {
    var isMember: Bool
    var registerToken: String
    var accessToken: String
    var refreshToken: String
    var name: String
    var id: String
}
