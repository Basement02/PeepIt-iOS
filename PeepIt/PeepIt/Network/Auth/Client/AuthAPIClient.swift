//
//  AuthAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 3/28/25.
//

import Foundation
import ComposableArchitecture

/// 인증 관련 API
struct AuthAPIClient {
    var checkIdDuplicate: (String) async throws -> ()
}

extension AuthAPIClient: DependencyKey {

    static let liveValue: AuthAPIClient = AuthAPIClient(
        checkIdDuplicate: { id in
            let requestDto: IdCheckRequestDto = .init(id: id)
            let requestAPI = AuthAPI.getIdCheckResult(requestDto)
            let response: EmptyDecodable =  try await APIFetcher.shared.fetch(of: requestAPI)
        }
    )
}

extension DependencyValues {

    var authAPIClient: AuthAPIClient {
        get { self[AuthAPIClient.self] }
        set { self[AuthAPIClient.self] = newValue }
    }
}
