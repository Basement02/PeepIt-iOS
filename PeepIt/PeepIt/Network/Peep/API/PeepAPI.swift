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
    case getMapPeeps(MapPeepRequestDto)
    case getHotPeeps(PageRequestDto)
    case postPeep(PeepUploadRequestDto, Data, Bool)
    case getCurrentLocationInfo(CurrentAddressRequestDto)
}

extension PeepAPI: APIType {

    var baseURL: URL {
        switch self {
        case .getCurrentLocationInfo:
            return URL(string: "https://dapi.kakao.com/v2/local/geo")!
        default:
            return URL(string: Environment.baseURL)!
        }
    }


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
        case .postPeep:
            return "/v1/peep/post"
        case .getCurrentLocationInfo:
            return "/coord2address"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postPeep:
            return .post

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
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .getOtherPeeps(requestDto):
            return .requestJSONEncodable(body: requestDto)

        case let .getPeepDetail(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .getMapPeeps(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())

        case let .postPeep(requestDto, media, isVideo):
            var parts: [MultipartFormDataPart] = []

            if let dtoData = try? JSONEncoder().encode(requestDto) {
                parts.append(
                    MultipartFormDataPart(
                        name: "peepData",
                        data: dtoData,
                        filename: nil,
                        mimeType: "application/json"
                    )
                )
            }

            parts.append(
                MultipartFormDataPart(
                    name: "media",
                    data: media,
                    filename: isVideo ? "peep_video.mp4" : "peep.jpg",
                    mimeType: isVideo ? "video/mp4" : "image/jpeg"
                )
            )
            return .requestWithMultipartFormData(formData: parts)

        case let .getCurrentLocationInfo(requestDto):
            return .requestParameters(parameters: requestDto.toDictionary())
        }
    }

    var header: HeaderType {
        switch self {
        case .getCurrentLocationInfo:
            return .kakaoLocalHeader

        default:
            return .jwtToken
        }
    }
}
