//
//  AuthAPI.swift
//  PeepIt
//
//  Created by 김민 on 3/28/25.
//

import Foundation
import Alamofire

enum AuthAPI {
    case getPhoneCheckResult(PhoneNumberRequest)
    case getIdCheckResult(IdCheckRequestDto)
    case requestSMSCode(PhoneNumberRequest)
    case getSMSCodeVerifyResult(CodeCheckRequestDto)
    case loginWithSocialAccount(LoginRequestDto)
    case logout
}

extension AuthAPI: APIType {

    var path: String {
        switch self {
        case .getPhoneCheckResult:
            return "/v1/auth/check/phone"
        case .getIdCheckResult:
            return "/v1/auth/check/id"
        case .requestSMSCode:
            return "/v1/auth/send/sms-code"
        case .getSMSCodeVerifyResult:
            return "/v1/auth/verify/sms-code"
        case .loginWithSocialAccount:
            return "/v1/auth/social"
        case .logout:
            return "/v1/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestSMSCode,
                .getSMSCodeVerifyResult,
                .loginWithSocialAccount:
            return .post
        case .logout:
            return .delete
        default:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getPhoneCheckResult(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .getIdCheckResult(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .requestSMSCode(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .getSMSCodeVerifyResult(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .loginWithSocialAccount(requestDto):
            return .requestJSONEncodable(body: requestDto)

        case .logout:
            return .requestPlain
        }
    }

    var header: HeaderType {
        switch self {
        case .getPhoneCheckResult, .requestSMSCode, .getSMSCodeVerifyResult, .logout:
            return .jwtToken
            
        case .getIdCheckResult, .loginWithSocialAccount:
            return .none
        }
    }
}
