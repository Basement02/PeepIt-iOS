//
//  ModifyProfileRequestDto.swift
//  PeepIt
//
//  Created by 김민 on 4/15/25.
//

import Foundation

struct ModifyProfileRequestDto: Encodable {
    var nickname: String
    var birth: String
    var gender: String
    var isAgree: Bool
}
