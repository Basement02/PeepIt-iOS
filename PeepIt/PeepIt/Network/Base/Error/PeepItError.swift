//
//  NetworkError.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation

/// PeepItError: 서버 정의 에러 및 에러 코드
enum PeepItError: String, Error {
    case noPeep = "40101"                     // 40101 - 존재하지 않는 핍
    case incorrectVerificationCode = "40102"  // 40102 - 인증 번호가 틀립니다
    case duplicateId = "40901"                // 40901 - 이미 사용 중인 아이디
    case duplicatePhoneNumber = "40902"       // 40902 - 이미 사용 중인 전화번호
    case internalServerError = "50000"        // 50000 - 서버 내부 오류
    case verificationCodeFailure = "50001"    // 50001 - 인증 번호 전송 실패
    case smsCodeFailed = "41001"              // 41001 - 인증 번호 관련 오류
    case smsCodeInvalidate = "40103"          // 40103 - 유효하지 않은 인증 번호
    case bCodeError = "40403"                 // 40403 - 법정동 관련 에러
}

extension Error {

    func asPeepItError() -> PeepItError? {
        guard
            let networkError = self as? NetworkError,
            case let .serverError(exception) = networkError,
            let errorCase = PeepItError(rawValue: exception.code)
        else {
            return nil
        }
        
        return errorCase
    }
}
