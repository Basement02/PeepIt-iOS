//
//  TownAPI.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation
import Alamofire

enum TownAPI {
    case getLegalCode(LegalCodeRequestDto)
    case patchUserTown(ModifyTownRequestDto)
}

extension TownAPI: APIType {

    var baseURL: URL {
        switch self {
        case .getLegalCode:
            return URL(string: "https://dapi.kakao.com/v2/local/geo")!
        default:
            return URL(string: Environment.baseURL)!
        }
    }

    var path: String {
        switch self {
        case .getLegalCode:
            return "/coord2regioncode"
        case .patchUserTown:
            return "/v1/member/town"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getLegalCode:
            return .get
            
        case .patchUserTown:
            return .patch
        }
    }

    var task: APITask {
        switch self {
        case let .getLegalCode(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .patchUserTown(requestDto):
            return .requestJSONEncodable(body: requestDto)
        }
    }

    var header: HeaderType {
        switch self {

        case .getLegalCode:
            return .kakaoLocalHeader

        default:
            return .jwtToken
        }
    }
}
