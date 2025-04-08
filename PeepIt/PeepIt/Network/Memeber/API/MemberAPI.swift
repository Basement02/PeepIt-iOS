//
//  MemberAPI.swift
//  PeepIt
//
//  Created by 김민 on 4/7/25.
//

import Foundation
import Alamofire

enum MemberAPI {
    case getMemberDetail
    case signUp(SignUpDto, String)
}

extension MemberAPI: APIType {

    var path: String {
        switch self {
        case .getMemberDetail:
            return "/v1/member/detail"
        case .signUp:
            return "/v1/member/sign-up"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMemberDetail:
            return .get
        case .signUp:
            return .post
        }
    }
    
    var task: APITask {
        switch self {
        case .getMemberDetail:
            return .requestPlain
        case let .signUp(requestDto, _):
            return .requestJSONEncodable(body: requestDto)
        }
    }

    var header: HTTPHeaders? {
        switch self {
        case let .signUp(_, registerToken):
            // TODO: - interceptor에서 헤더 넣어주기
            return ["Authorization": "Register \(registerToken)"]
        default:
            return ["Authorization": "Bearer "]
        }
    }
}
