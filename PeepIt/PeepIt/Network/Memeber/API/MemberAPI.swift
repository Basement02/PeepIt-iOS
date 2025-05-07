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
    case getOtherMemberDetail(String)
    case signUp(SignUpDto, String)
    case patchUserProfileImage(ProfileImgRequestDto)
    case patchUserProfile(ModifyProfileRequestDto)
}

extension MemberAPI: APIType {

    var path: String {
        switch self {
        case .getMemberDetail:
            return "/v1/member/detail"
        case let .getOtherMemberDetail(memberId):
            return "/v1/member/detail/\(memberId)"
        case .signUp:
            return "/v1/member/sign-up"
        case .patchUserProfileImage:
            return "/v1/member/profile-img"
        case .patchUserProfile:
            return "/v1/member/detail"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMemberDetail, .getOtherMemberDetail:
            return .get
        case .signUp:
            return .post
        case .patchUserProfileImage, .patchUserProfile:
            return .patch
        }
    }
    
    var task: APITask {
        switch self {
            
        case .getMemberDetail:
            return .requestPlain

        case let .getOtherMemberDetail(memberId):
            return .requestParameters(parameters: memberId.toDictionary())

        case let .signUp(requestDto, _):
            return .requestJSONEncodable(body: requestDto)

        case let .patchUserProfileImage(requestDto):
            var parts: [MultipartFormDataPart] = []

            let part = MultipartFormDataPart(
                name: "profileImg",
                data: requestDto.profileImg,
                filename: "profile.jpg",
                mimeType: "image/jpeg"
            )

            parts.append(part)

            return .requestWithMultipartFormData(formData: parts)

        case let .patchUserProfile(requestDto):
            return .requestJSONEncodable(body: requestDto)
        }
    }

    var header: HTTPHeaders? {
        switch self {
        case let .signUp(_, registerToken):
            // TODO: - interceptor에서 헤더 넣어주기
            return ["Authorization": "Register \(registerToken)"]
        default:
            return ["Authorization": "Bearer \(Environment.jwtTokenTmp)"]
        }
    }
}
