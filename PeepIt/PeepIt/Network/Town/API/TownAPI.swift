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
}

extension TownAPI: APIType {

    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com/v2/local/geo/coord2regioncode")!
    }

    var path: String {
        return ""
    }

    var method: HTTPMethod {
        switch self {

        default:
            return .get
        }
    }

    var task: APITask {
        switch self {
        case let .getLegalCode(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())
        }
    }

    var header: HTTPHeaders? {
        return ["Authorization": "KakaoAK \(Environment.kakaoRestAPIKey)"]
    }
}
