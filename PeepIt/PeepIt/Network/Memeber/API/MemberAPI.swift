//
//  MemberAPI.swift
//  PeepIt
//
//  Created by 김민 on 4/7/25.
//

import Foundation
import Alamofire

enum MemberAPI {
    case signUp(SignUpDto)
}

extension MemberAPI: APIType {

    var path: String {
        switch self {
        case .signUp:
            return "/v1/member/sign-up"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: APITask {
        switch self {
        case let .signUp(requestDto):
            return .requestJSONEncodable(body: requestDto)
        }
    }

    var header: HTTPHeaders? {
        switch self {
        case .signUp:
            return ["Authorization": "Register "]
        }
    }
}
