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
        case peepDetail(PeepDetailStore)
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

        Scope(state: \.home, action: \.home) { HomeStore() }

        Scope(state: \.login, action: \.login) { LoginStore() }

        Reduce { state, action in
            switch action {

            case .finishLoading:
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
                state.authState = .unAuthorized
                state.path.removeAll()
                return .none

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

                case .element(_, action: .townPeeps(.uploadButtonTapped)):
                    state.path.append(.camera(.init()))
                    return .none

                case .element(_, action: .inputAuthCode(.pushToWelcomeView)):
                    state.path.append(.welcome(.init()))
                    return .none

                case .element(_, action: .myProfile(.watchButtonTapped)):
                    state.path.removeAll()
                    return .none

                case let .element(_, action: .townPeeps(.peepCellTapped(idx, peeps))):
                    state.path.append(
                        .peepDetail(PeepDetailStore.State(
                            entryType: .townPeep,
                            peepList: peeps,
                            currentIdx: idx,
                            showPeepDetailObject: true,
                            showPeepDetailBg: true
                        ))
                    )
                    return .none

                case let .element(_, action: .notification(.activePeepCellTapped(selectedPeep))):
                    state.path.append(
                        .peepDetail(PeepDetailStore.State(
                            entryType: .others,
                            peepList: [selectedPeep],
                            currentIdx: 0,
                            showPeepDetailObject: true,
                            showPeepDetailBg: true
                        ))
                    )
                    return .none

                case let .element(_, action: .myProfile(.peepCellTapped(selectedPeep))):
                    state.path.append(
                        .peepDetail(PeepDetailStore.State(
                            entryType: .others,
                            peepList: [selectedPeep],
                            currentIdx: 0,
                            showPeepDetailObject: true,
                            showPeepDetailBg: true
                        ))
                    )

                    return .none

                case let .element(_, action: .otherProfile(.peepCellTapped(selectedPeep))):
                    state.path.append(
                        .peepDetail(PeepDetailStore.State(
                            entryType: .others,
                            peepList: [selectedPeep],
                            currentIdx: 0,
                            showPeepDetailObject: true,
                            showPeepDetailBg: true
                        ))
                    )

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
