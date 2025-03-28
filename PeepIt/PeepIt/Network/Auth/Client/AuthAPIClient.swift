//
//  AuthAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 3/28/25.
//

import Foundation
import ComposableArchitecture

/// 핍 관련 API
struct AuthAPIClient {
    
}

extension AuthAPIClient: DependencyKey {

    static let liveValue: AuthAPIClient = AuthAPIClient()
}

extension DependencyValues {

    var authAPIClient: AuthAPIClient {
        get { self[AuthAPIClient.self] }
        set { self[AuthAPIClient.self] = newValue }
    }
}
