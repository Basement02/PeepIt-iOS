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
        /// 로그인
        case login(LoginStore)

        /// 홈
        case home(HomeStore)

        /// 사이드메뉴
        case setting(SettingStore)
        case townPeeps(TownPeepsStore)
        case notificaiton(NotificationStore)
        case announce(AnnounceStore)

        /// 프로필
        case myProfile(MyProfileStore)
        case profileModify(ProfileModifyStore)
        case nicknameModify(ProfileModifyStore)
        case genderModify(ProfileModifyStore)


        /// 회원가입
        case term(TermStore)
        case inputId(InputIdStore)
        case nickname(NicknameStore)
        case authentication(AuthenticationStore)
        case welcome(WelcomeStore)

        /// 업로드
        case camera(CameraStore)
        case edit(EditStore)
        case write(WriteStore)
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
//                state.authState = .authorized
                state.path.append(.term(.init()))
                return .none

            case let .path(action):
                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
