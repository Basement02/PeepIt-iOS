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
    case kakaoLocalHeader
    case none

    var tokenKey: String? {
        switch self {
        case .jwtToken:
            return TokenType.access.rawValue
        case .refreshToken:
            return TokenType.refresh.rawValue
        case .registerToken:
            return TokenType.register.rawValue
        case .kakaoLocalHeader, .none:
            return nil
        }
    }

    var staticHeader: HTTPHeader? {
        switch self {
        case .kakaoLocalHeader:
            return HTTPHeader(name: "Authorization", value: "KakaoAK \(Environment.kakaoRestAPIKey)")
        default:
            return nil
        }
    }

    var prefix: String {
        switch self {
        case .jwtToken, .refreshToken:
            return "Bearer"
        case .registerToken:
            return "Register"
        default:
            return ""
        }
    }
}
