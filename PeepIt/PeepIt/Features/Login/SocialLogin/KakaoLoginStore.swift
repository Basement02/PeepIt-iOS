//
//  KakaoLoginStore.swift
//  PeepIt
//
//  Created by 김민 on 4/1/25.
//

import Foundation
import ComposableArchitecture
import KakaoSDKUser

@Reducer
struct KakaoLoginStore {

    @ObservableState
    struct State: Equatable { }

    enum Action {
        case kakaoLoginTapped
        case loginSucceeded(idToken: String)
        case loginFailed(error: LoginErrorType)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .kakaoLoginTapped:
                return .run { @MainActor send in
                    do {
                        let idToken = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
                            // 카카오톡 열기 가능할 경우
                            if UserApi.isKakaoTalkLoginAvailable() {
                                // 카카오톡으로 로그인
                                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                                    if let error = error {
                                        continuation.resume(throwing: LoginErrorType.unknown(error))
                                    } else if let idToken = oauthToken?.idToken {
                                        continuation.resume(returning: idToken)
                                    } else {
                                        continuation.resume(throwing: LoginErrorType.idTokenMissing)
                                    }
                                }
                            } else {
                                // 카카오 계정으로 로그인
                                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                                    if let error = error {
                                        continuation.resume(throwing: LoginErrorType.unknown(error))
                                    } else if let idToken = oauthToken?.idToken {
                                        continuation.resume(returning: idToken)
                                    } else {
                                        continuation.resume(throwing: LoginErrorType.idTokenMissing)
                                    }
                                }
                            }
                        }

                        send(.loginSucceeded(idToken: idToken))
                    } catch let error as LoginErrorType {
                        send(.loginFailed(error: error))
                    } catch {
                        send(.loginFailed(error: .unknown(error)))
                    }
                }

            case let .loginSucceeded(idToken):
                print("idToken", idToken)
                return .none

            case let .loginFailed(error):
                print(error)
                return .none
            }
        }
    }
}
