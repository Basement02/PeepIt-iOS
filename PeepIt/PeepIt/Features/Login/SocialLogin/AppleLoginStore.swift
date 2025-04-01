//
//  AppleLoginStore.swift
//  PeepIt
//
//  Created by 김민 on 4/1/25.
//

import AuthenticationServices
import Foundation
import ComposableArchitecture

@Reducer
struct AppleLoginStore {

    @ObservableState
    struct State: Equatable { }

    enum Action {
        case appleLoginRequest(request: ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(result: Result<ASAuthorization, Error>)
        case loginSucceeded(idToken: String)
        case loginFailed(error: LoginErrorType)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .appleLoginRequest(request):
                request.requestedScopes = [.email]
                return .none

            case let .appleLoginCompletion(result):

                switch result {

                case let .success(authorization):
                    guard
                        let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                        let tokenData = credential.identityToken,
                        let tokenString = String(data: tokenData, encoding: .utf8)
                    else {
                        return .send(.loginFailed(error: .invalidResponse))
                    }

                    return .send(.loginSucceeded(idToken: tokenString))


                case let .failure(error):
                    return .send(.loginFailed(error: .unknown(error)))
                }

            case let .loginSucceeded(idToken):
                print("idToken", idToken)
                // TODO: 로그인 api 호출
                return .none

            case let .loginFailed(error):
                print(error)
                return .none
            }
        }
    }
}
