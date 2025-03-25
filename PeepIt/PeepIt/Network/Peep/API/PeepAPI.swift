//
//  PeepAPI.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation
import Alamofire

/// 핍 관련 API
enum PeepAPI {
    case getMyUploadedPeeps(PageRequestDto)
    case getReactedPeeps(PageRequestDto)
    case getChattedPeeps(PageRequestDto)
    case getActivePeeps(PageRequestDto)
    case getOtherPeeps(PageAndIdRequestDto)
    case getPeepDetail(PeepDetailRequestDto)
    case getRecentTownPeeps(PageRequestDto)
    case getMapPeeps(MapPeepRequest)
    case getHotPeeps(PageRequestDto)
    // TODO: - 신규 핍 등록 api
}

extension PeepAPI: APIType {

    var path: String {
        switch self {
        case .getMyUploadedPeeps:
            return "/v1/peep/my/upload"
        case .getReactedPeeps:
            return "/v1/peep/my/react"
        case .getChattedPeeps:
            return "/v1/peep/my/chat"
        case .getActivePeeps:
            return "/v1/peep/my/active"
        case .getOtherPeeps:
            return "/v1/peep/get"
        case let .getPeepDetail(requestDto):
            return "/v1/peep/get/\(requestDto.peepId)"
        case .getRecentTownPeeps:
            return "/v1/peep/get/town"
        case .getMapPeeps:
            return "/v1/peep/get/map"
        case .getHotPeeps:
            return "/v1/peep/get/hot"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var task: APITask {
        switch self {
        /// requestDto: PageRequestDto
        case let .getMyUploadedPeeps(requestDto),
            let .getReactedPeeps(requestDto),
            let .getChattedPeeps(requestDto),
            let .getActivePeeps(requestDto),
            let .getRecentTownPeeps(requestDto),
            let .getHotPeeps(requestDto):
            return .requestJSONEncodable(body: requestDto)

        case let .getOtherPeeps(requestDto):
            return .requestJSONEncodable(body: requestDto)

        case let .getPeepDetail(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .getMapPeeps(requestDto):
            return .requestJSONEncodable(body: requestDto)
        }
    }
}
