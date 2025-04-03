//
//  CodeCheckRequestDto.swift
//  PeepIt
//
//  Created by 김민 on 4/3/25.
//

import Foundation

struct CodeCheckRequestDto: Encodable {
    var phone: String
    var code: String
}
