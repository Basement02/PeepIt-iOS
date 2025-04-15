//
//  MemberAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation
import ComposableArchitecture

struct MemberAPIClient {
    var getMemberDetail: () async throws -> UserProfile
    var signUp: (UserInfo, String) async throws -> Token
    var modifyUserProfileImage: (Data) async throws -> String
    var modifyUserProfle: (UserProfile) async throws -> UserProfile
}

extension MemberAPIClient: DependencyKey {

    static let liveValue: MemberAPIClient = MemberAPIClient(
        getMemberDetail: { 
            let requestAPI: MemberAPI = .getMemberDetail
            let response: MemberDetailResponseDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        signUp: { user, registerToken in
            let requestDto: SignUpDto = .init(
                id: user.id,
                nickname: user.nickname,
                birth: user.birth,
                gender: user.gender.type,
                isAgree: user.isAgree
            )

            let requestAPI: MemberAPI = .signUp(requestDto, registerToken)
            let response: LoginResponseDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        modifyUserProfileImage: { data in
            let requestDto: ProfileImgRequestDto = .init(profileImg: data)
            let requestAPI: MemberAPI = .patchUserProfileImage(requestDto)
            let response: MemberDetailResponseDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.profile
        },
        modifyUserProfle: { profile in
            let requestDto: ModifyProfileRequestDto = .init(
                nickname: profile.name,
                birth: "", // TODO:
                gender: profile.gender.type,
                isAgree: profile.isAgree
            )
            let requestAPI: MemberAPI = .patchUserProfile(requestDto)
            let response: MemberDetailResponseDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        }
    )
}

extension DependencyValues {

    var memberAPIClient: MemberAPIClient {
        get { self[MemberAPIClient.self] }
        set { self[MemberAPIClient.self] = newValue }
    }
}
