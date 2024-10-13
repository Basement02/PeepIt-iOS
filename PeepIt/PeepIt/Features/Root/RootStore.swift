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
        case login(LoginStore)
        case home(HomeStore)
        case myProfile(MyProfileStore)
        case setting(SettingStore)
        case townPeeps(TownPeepsStore)
        case notificaiton(NotificationStore)
        case announce(AnnounceStore)
        case camera(CameraStore)
        case profileModify(ProfileModifyStore)
        case nicknameModify(ProfileModifyStore)
        case genderModify(ProfileModifyStore)
        case term(TermStore)
        case inputId(InputIdStore)
        case nickname(NicknameStore)
        case authentication(AuthenticationStore)
        case welcome(WelcomeStore)
    }

    @ObservableState
    struct State {
        var path = StackState<Path.State>()

        var authState = AuthState.authorized

        var login = LoginStore.State()
        var home = HomeStore.State()
    }

    enum Action {
        case path(StackActionOf<Path>)

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

            case .login(.loginButtonTapped):
//                state.authState = .authorized
                state.path.append(.term(.init()))
                return .none

            case let .path(action):

                switch action {

                    /// 프로필: 프로필 뒤로가기 버튼
                case let .element(id, action: .myProfile(.backButtonTapped)):
                    state.path.pop(from: id)
                    return .none

                    /// 프로필: 핍 없을 시 핍 업로드 버튼
                case .element(id: _, action: .myProfile(.uploadButtonTapped)):
                    state.path.append(.camera(.init()))
                    return .none

                    /// 프로필: 수정 버튼
                case .element(id: _, action: .myProfile(.modifyButtonTapped)):
                    state.path.append(.profileModify(.init()))
                    return .none

                    /// 프로필: 닉네임
                case .element(id: _, action: .profileModify(.nicknameButtonTapped)):
                    state.path.append(.nicknameModify(.init()))
                    return .none

                    /// 약관 -> 아이디
                case .element(id: _, action: .term(.nextButtonTapped)):
                    state.path.append(.inputId(.init()))
                    return .none

                    /// 아이디 -> 닉네임
                case .element(id: _, action: .inputId(.nextButtonTapped)):
                    state.path.append(.nickname(.init()))
                    return .none

                    /// 닉네임  -> 본인인증
                case .element(id: _, action: .nickname(.nextButtonTapped)):
                    state.path.append(.authentication(.init()))
                    return .none

                    /// 본인인증 -> 웰컴
                case let .element(
                    id: _,
                    action: .authentication(.bottomButtonTapped(isStartAuthButton))
                ):
                    if !isStartAuthButton { state.path.append(.welcome(.init())) }
                    return .none

                    /// 웰컴 -> 홈
                case .element(id: _, action: .welcome(.goToHomeButtonTapped)):
                    state.path.removeAll()
                    state.authState = .authorized
                    return .none

                default:
                    return .none
                }

                /// 홈: 프로필로 이동
            case .home(.profileButtonTapped):
                state.path.append(.myProfile(.init()))
                return .none

                /// 사이드메뉴: 설정으로 이동
            case .home(.sideMenu(.settingButtonTapped)):
                state.path.append(.setting(.init()))
                return .none

                /// 사이드메뉴: 메뉴 버튼
            case let .home(.sideMenu(.menuTapped(type))):
                switch type {
                case .notification:
                    state.path.append(.notificaiton(.init()))
                    return .none

                case .peepItNews:
                    state.path.append(.announce(.init()))
                    return .none

                case .townPeeps:
                    state.path.append(.townPeeps(.init()))
                    return .none
                }

            case .home(.uploadButtonTapped):
                state.path.append(.camera(.init()))
                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
