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

        /// 더보기
        case announce(AnnounceStore)
        case townPeeps(TownPeepsStore)
        case notification(NotificationStore)

        /// 설정
        case setting(SettingStore)
        case guide(GuideStore)
        case notificationSetting(NotificationSettingStore)
        case blockList(BlockListStore)

        /// 프로필
        case otherProfile(OtherProfileStore)
        case myProfile(MyProfileStore)

        // 업로드
        case camera(CameraStore)
        case edit(EditStore)
        case write(WriteStore)
    }

    @ObservableState
    struct State {
        var path = StackState<Path.State>()

        var isLoading = true
        var authState = AuthState.authorized

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

            case .home(.profileButtonTapped):
                state.path.append(.myProfile(.init()))
                return .none

            case .home(.sideMenu(.notificationMenuTapped)):
                state.path.append(.notification(.init()))
                return .none

            case .home(.uploadButtonTapped):
                state.path.append(.camera(.init()))
                return .none

            case let .path(action):
                switch action {

                case .element(_, action: .welcome(.goToHomeButtonTapped)):
                    state.authState = .authorized
                    state.path.removeAll()
                    return .none

                case .element(_, action: .myProfile(.uploadButtonTapped)):
                    state.path.append(.camera(.init()))
                    return .none

                case let .element(_, action: .camera(.pushToEdit(image, videoURL))):
                    state.path.append(
                        .edit(EditStore.State(image: image, videoURL: videoURL))
                    ) 
                    return .none

                case let .element(_, action: .edit(.captureImage(image))):
                    state.path.append(.write(WriteStore.State(image: image)))
                    return .none

                case .element(_, action: .write(.uploadButtonTapped)):
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
