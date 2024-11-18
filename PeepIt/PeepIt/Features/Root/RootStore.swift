//
//  RootStore.swift
//  PeepIt
//
//  Created by 김민 on 9/28/24.
//

import Foundation
import ComposableArchitecture

enum AuthState: Equatable {
    case unAuthorized
    case authorized
}

@Reducer
struct RootStore {

    @Reducer(state: .equatable)
    enum Path {
        /// 회원가입
        case term(TermStore)
        case inputId(InputIdStore)
        case nickname(NicknameStore)
        case inputProfle(ProfileInfoStore)
        case inputPhoneNumber(AuthenticationStore)
        case inputAuthCode(EnterAuthCodeStore)
        case welcome(WelcomeStore)
    }

    @ObservableState
    struct State {
        var path = StackState<Path.State>()

        var isLoading = true
        var authState = AuthState.unAuthorized

        var login = LoginStore.State()
        var home = HomeStore.State()
    }

    enum Action {
        case path(StackActionOf<Path>)

        case finishLoading

        case login(LoginStore.Action)
        case home(HomeStore.Action)
    }

    var body: some Reducer<State, Action> {

        Scope(state: \.home, action: \.home) {
            HomeStore()
        }

        Scope(state: \.login, action: \.login) {
            LoginStore()
        }

        Reduce { state, action in
            switch action {

            case .finishLoading:
                state.isLoading = false
                return .none

            case .login(.loginButtonTapped):
                state.path.append(.term(.init()))
                return .none

            case let .path(action):
                switch action {

                case .element(_, action: .welcome(.goToHomeButtonTapped)):
                    state.authState = .authorized
                    state.path.removeAll()
                    return .none

                default:
                    return .none
                }

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
