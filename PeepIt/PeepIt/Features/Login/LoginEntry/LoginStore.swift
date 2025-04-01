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
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonTapped(type: LoginType)
        case kakaoLoginAction(KakaoLoginStore.Action)
        case appleLoginAction(AppleLoginStore.Action)
    }

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

                switch type {
                case .kakao:
                    return .send(.kakaoLoginAction(.kakaoLoginTapped))
                case .naver, .apple:
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
