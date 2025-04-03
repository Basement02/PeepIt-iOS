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
        }
    )
}

extension DependencyValues {

    var authAPIClient: AuthAPIClient {
        get { self[AuthAPIClient.self] }
        set { self[AuthAPIClient.self] = newValue }
    }
}
