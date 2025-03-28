//
//  AuthAPI.swift
//  PeepIt
//
//  Created by 김민 on 3/28/25.
//

import Foundation
import Alamofire

enum AuthAPI {
    case getPhoneCheckResult(PhoneCheckRequestDto)
    case getIdCheckResult(IdCheckRequestDto)
}

extension AuthAPI: APIType {

    var path: String {
        switch self {
        case .getPhoneCheckResult:
            return "/v1/auth/check/phone"
        case .getIdCheckResult:
            return "/v1/auth/check/id"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var task: APITask {
        switch self {
        case let .getPhoneCheckResult(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())
        case let .getIdCheckResult(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())
        }
    }
    
    var header: HTTPHeaders? {
        return nil
    }
}
