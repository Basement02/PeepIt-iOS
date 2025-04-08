//
//  LoginRequestDto.swift
//  PeepIt
//
//  Created by 김민 on 4/7/25.
//

import Foundation

struct LoginRequestDto: Encodable {
    var provider: String
    var idToken: String
}
