//
//  SignUpDto.swift
//  PeepIt
//
//  Created by 김민 on 4/7/25.
//

import Foundation

struct SignUpDto: Encodable {
    var id: String
    var nickname: String
    var birth: String?
    var gender: String?
    var isAgree: Bool
}
