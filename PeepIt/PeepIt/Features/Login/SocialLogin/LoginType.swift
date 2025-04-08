//
//  LoginType.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation

enum LoginType: String, CaseIterable, Hashable {
    case kakao = "KAKAO"
    case naver = "NAVER"
    case apple = "APPLE"

    var description: String {
        switch self {
        case .kakao:
            return "카카오"
        case .naver:
            return "네이버"
        case .apple:
            return "애플"
        }
    }
}

enum LoginErrorType: Error {
    case invalidResponse
    case cancelled
    case unknown(Error)
}
