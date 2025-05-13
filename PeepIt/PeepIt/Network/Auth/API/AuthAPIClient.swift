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
    var checkPhoneDuplicated: (String) async throws -> ()
    var checkIdDuplicated: (String) async throws -> ()
    var sendSMSCode: (String) async throws -> ()
    var checkSMSCodeVerified: (String, String) async throws -> ()
    var login: (String, String) async throws -> Token // 추후 로그인 타입으로 수정
    var logout: () async throws -> ()
}

extension AuthAPIClient: DependencyKey {

    static let liveValue: AuthAPIClient = AuthAPIClient(
        checkPhoneDuplicated: { phoneNumber in
            let requestDto: PhoneNumberRequest = .init(phone: phoneNumber)
            let requestAPI = AuthAPI.getPhoneCheckResult(requestDto)
            let response: EmptyDecodable =  try await APIFetcher.shared.fetch(of: requestAPI)
        },
        checkIdDuplicated: { id in
            let requestDto: IdCheckRequestDto = .init(id: id)
            let requestAPI = AuthAPI.getIdCheckResult(requestDto)
            let response: EmptyDecodable =  try await APIFetcher.shared.fetch(of: requestAPI)
        },
        sendSMSCode: { phoneNumber in
            let requestDto: PhoneNumberRequest = .init(phone: phoneNumber)
            let requestAPI = AuthAPI.requestSMSCode(requestDto)
            let response: EmptyDecodable =  try await APIFetcher.shared.fetch(of: requestAPI)
        },
        checkSMSCodeVerified: { phoneNumber, code in
            let requestDto: CodeCheckRequestDto = .init(phone: phoneNumber, code: code)
            let requestAPI = AuthAPI.getSMSCodeVerifyResult(requestDto)
            let response: EmptyDecodable =  try await APIFetcher.shared.fetch(of: requestAPI)
        },
        login: { provider, idToken in //
            let requestDto: LoginRequestDto = .init(provider: provider, idToken: idToken)
            let requestAPI = AuthAPI.loginWithSocialAccount(requestDto)
            let response: LoginResponseDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        logout: {
            let requestAPI = AuthAPI.logout
            let response: EmptyDecodable = try await APIFetcher.shared.fetch(of: requestAPI)
        }
    )
}

extension DependencyValues {

    var authAPIClient: AuthAPIClient {
        get { self[AuthAPIClient.self] }
        set { self[AuthAPIClient.self] = newValue }
    }
}
