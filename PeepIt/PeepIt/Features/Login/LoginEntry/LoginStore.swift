//
//  LoginStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LoginStore {

    @ObservableState
    struct State: Equatable {
        var currentTab = 0

        var kakaoLoginState = KakaoLoginStore.State()
        var appleLoginState = AppleLoginStore.State()

        @Shared(.inMemory("register")) var registerToken = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonTapped(type: LoginType)

        /// idToken 추출 소셜 로그인 api
        case kakaoLoginAction(KakaoLoginStore.Action)
        case appleLoginAction(AppleLoginStore.Action)

        /// 핍잇 서버 로그인 api
        case loginWithIdToken(type: LoginType)
        case fetchLoginResponse(Result<Token, Error>)

        /// 기존 회원 여부에 맞게 화면 전환
        case moveToTerm
        case moveToHome
    }

    @Dependency(\.authAPIClient) var authAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.kakaoLoginState, action: \.kakaoLoginAction) {
            KakaoLoginStore()
        }

        Scope(state: \.appleLoginState, action: \.appleLoginAction) {
            AppleLoginStore()
        }

        Reduce { state, action in
            switch action {
            case .binding(\.currentTab):
                return .none

            case let .loginButtonTapped(type):

                // TODO: - 소셜 로그인 주석 풀기
//                switch type {
//                case .kakao:
//                    return .send(.kakaoLoginAction(.kakaoLoginTapped))
//                case .naver, .apple:
//                    return .none
//                }

                return .send(.loginWithIdToken(type: type))

            // TODO: 각 로그인 타입으로 수정
            case .loginWithIdToken:
                return .run { send in
                    await send(
                        .fetchLoginResponse(
                            Result { try await authAPIClient.login("TESTER", UUID().uuidString) }
                        )
                    )
                }

            case let .fetchLoginResponse(result):
                switch result {

                case let .success(res):
                    if res.isNewMember {
                        state.registerToken = res.registerToken
                        return .send(.moveToTerm)
                    } else {
                        // TODO: 키체인에 access, refresh 토큰 저장 및 홈으로 이동
                        return .send(.moveToHome)
                    }

                case .failure:
                    print("error")
                }

                return .none

            case .moveToTerm, .moveToHome:
                return .none

            default:
                return .none
            }
        }
    }
}
