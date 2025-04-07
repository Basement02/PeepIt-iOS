//
//  MemberAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation
import ComposableArchitecture

struct MemberAPIClient {
    var signUp: (UserProfile, String) async throws -> Token
}

extension MemberAPIClient: DependencyKey {

    static let liveValue: MemberAPIClient = MemberAPIClient(
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
        }
    )
}

extension DependencyValues {

    var memberAPIClient: MemberAPIClient {
        get { self[MemberAPIClient.self] }
        set { self[MemberAPIClient.self] = newValue }
    }
}
