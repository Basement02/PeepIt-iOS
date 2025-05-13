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

        Reduce { state, action in
            switch action {

            case .finishLoading:
                // TODO: 토큰 만료 여부, 토큰 존재 여부에 따라 분기
                guard let access = keychain.load(TokenType.access.rawValue) else {
                    state.authState = .unAuthorized
                    state.isLoading = false
                    return .none
                }

                return .send(.user(.getMyProfileFromServer))

            case .user(.didFinishLoadProfile):
                state.isLoading = false
                return .none

            case .login(.moveToTerm):
                state.path.append(.term(.init()))
                return .none

            case .login(.moveToHome):
                state.authState = .authorized
                state.path.removeAll()
                return .none

            case .home(.profileButtonTapped):
                state.path.append(.myProfile(.init()))
                return .none

            case .home(.sideMenu(.notificationMenuTapped)):
                state.path.append(.notification(.init()))
                return .none

            case .home(.sideMenu(.logoutButtonTapped)):
                return .send(.showPopUp(.logout))

            case .home(.uploadButtonTapped):
                state.path.append(.camera(.init()))
                return .none

            case let .path(action):
                switch action {

                case .element(_, action: .term(.nextButtonTapped)):
                    state.path.append(.inputId(.init()))
                    return .none

                case .element(_, action: .inputId(.nextButtonTapped)):
                    state.path.append(.nickname(.init()))
                    return .none

                case .element(_, action: .nickname(.nextButtonTapped)):
                    state.path.append(.inputProfle(.init()))
                    return .none

                case .element(_, action: .inputProfle(.moveToSMSAuth)):
                    state.path.append(.inputPhoneNumber(.init()))
                    return .none

                case .element(_, action: .inputPhoneNumber(.nextButtonTapped)):
                    state.path.append(.inputAuthCode(.init()))
                    return .none

                case .element(_, action: .inputPhoneNumber(.skipButtonTapped)):
                    state.path.append(.welcome(.init()))
                    return .none

                case let .element(_, action: .inputPhoneNumber(.moveToEnterCode(phone))):
                    state.path.append(
                        .inputAuthCode(.init(phoneNumber: phone))
                    )
                    return .none

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

                case let .element(_, action: .edit(.pushToWriteBody(image, videoURL))):
                    state.path.append(
                        .write(WriteStore.State(image: image, videoURL: videoURL))
                    )
                    return .none

                case .element(_, action: .write(.closeUploadFeature)):
                    for _ in 0..<3 { _ = state.path.popLast() }
                    return .none

                case .element(_, action: .townPeeps(.uploadButtonTapped)):
                    state.path.append(.camera(.init()))
                    return .none

                case .element(_, action: .inputAuthCode(.pushToWelcomeView)):
                    state.path.append(.welcome(.init()))
                    return .none

                case .element(_, action: .myProfile(.watchButtonTapped)):
                    state.path.removeAll()
                    return .none

                case let .element(_, action: .townPeeps(.peepCellTapped(idx, peepIdList, page, size))):
                    state.path.append(
                        .peepDetailList(PeepDetailListStore.State(
                            entryType: .townPeep,
                            currentIdx: idx,
                            showPeepDetailObject: true,
                            showPeepDetailBg: true,
                            size: size,
                            page: page,
                            peepIdList: peepIdList
                        ))
                    )
                    return .none

                case let .element(_, action: .notification(.activePeepCellTapped(selectedPeep))):
                    state.path.append(
                        .peepDetail(PeepDetailStore.State(isMine: true, peepId: selectedPeep.peepId))
                    )
                    return .none

                case let .element(_, action: .myProfile(.peepCellTapped(selectedPeep))):
                    state.path.append(
                        .peepDetail(PeepDetailStore.State(isMine: true, peepId: selectedPeep.peepId))
                    )
                    return .none

                case let .element(_, action: .otherProfile(.peepCellTapped(selectedPeep))):
                    state.path.append(
                        .peepDetail(PeepDetailStore.State(isMine: false, peepId: selectedPeep.peepId))
                    )
                    return .none

                case let .element(_, action: .peepDetailList(.profileTapped(id))):
                    state.path.append(.otherProfile(OtherProfileStore.State(userId: id)))
                    return .none

                default:
                    return .none
                }

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
