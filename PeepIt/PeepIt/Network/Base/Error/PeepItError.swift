//
//  NetworkError.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation

/// PeepItError: 서버 정의 에러 및 에러 코드
enum PeepItError: String, Error {
    case invalidSocialAccount = "40101"       // 40101 - 유효하지 않은 소셜 계정
    case incorrectVerificationCode = "40102"  // 40102 - 인증 번호가 틀립니다
    case duplicateId = "40901"          // 40901 - 이미 사용 중인 아이디
    case duplicatePhoneNumber = "40902"       // 40902 - 이미 사용 중인 전화번호
    case internalServerError = "50000"        // 50000 - 서버 내부 오류
    case verificationCodeFailure = "50001"    // 50001 - 인증 번호 전송 실패
}
