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
        case modifyProfile(ProfileModifyStore)
        case modifyNickname(ProfileModifyStore)
        case modifyGender(ProfileModifyStore)

        // 업로드
        case camera(CameraStore)
        case edit(EditStore)
        case write(WriteStore)

        /// 핍
        case peepDetailList(PeepDetailListStore)
        case peepDetail(PeepDetailStore)
    }

    @ObservableState
    struct State {
        var path = StackState<Path.State>()

        var isLoading = true
        var authState = AuthState.authorized

        var login = LoginStore.State()
        var home = HomeStore.State()
        var user = UserStore.State()

        var activePopUp: PopUpType? = nil
    }

    enum Action {
        case path(StackActionOf<Path>)

        case finishLoading

        case login(LoginStore.Action)
        case home(HomeStore.Action)
        case user(UserStore.Action)

        case showPopUp(PopUpType)
        case hidePopUp
        case popUpConfirmed(PopUpType)

        /// 로그아웃 api
        case logout
        case fetchLogoutResponse(Result<Void, Error>)
    }

    @Dependency(\.keychain) var keychain
    @Dependency(\.authAPIClient) var authAPIClient

    var body: some Reducer<State, Action> {

        Scope(state: \.home, action: \.home) { HomeStore() }

        Scope(state: \.login, action: \.login) { LoginStore() }

        Scope(state: \.user, action: \.user) { UserStore() }

        Scope(state: \.self, action: \.self) { RootPathStore() }

        Reduce { state, action in
            switch action {

            case .finishLoading:
                // TODO: 토큰 만료 여부, 토큰 존재 여부에 따라 분기
                guard let _ = keychain.load(TokenType.access.rawValue) else {
                    state.authState = .unAuthorized
                    state.isLoading = false
                    return .none
                }

                return .send(.user(.getMyProfileFromServer))

            case .user(.didFinishLoadProfile):
                state.isLoading = false
                return .none

            case let .showPopUp(popup):
                 state.activePopUp = popup
                 return .none

             case .hidePopUp:
                 state.activePopUp = nil
                 return .none

             case let .popUpConfirmed(popUp):
                 state.activePopUp = nil

                 switch popUp {
                 case .logout:
                     return .send(.logout)
                 }

            case .logout:
                return .run { send in
                    await send(
                        .fetchLogoutResponse(
                            Result { try await authAPIClient.logout() }
                        )
                    )
                }

            case let .fetchLogoutResponse(result):
                if case .success = result {
                    state.authState = .unAuthorized
                    state.path.removeAll()
                    _ = keychain.deleteAll()
                }

                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
