//
//  HeaderType.swift
//  PeepIt
//
//  Created by 김민 on 5/13/25.
//

import Foundation
import Alamofire

enum HeaderType {
    case jwtToken
    case refreshToken
    case registerToken
    case none
    case kakaoLocalHeader
}
