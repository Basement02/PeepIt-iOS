//
//  RootView.swift
//  PeepIt
//
//  Created by 김민 on 9/28/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Perception.Bindable var store: StoreOf<RootStore>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)
            ) {
                Group {
                    if store.isLoading {
                        LaunchScreen()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    store.send(.finishLoading, animation: .easeInOut)
                                }
                            }
                    } else {
                        switch store.authState {
                        case .unAuthorized:
                            LoginView(
                                store: store.scope(
                                    state: \.login,
                                    action: \.login
                                )
                            )

                        case .authorized:
                            HomeView(
                                store: store.scope(
                                    state: \.home,
                                    action: \.home
                                )
                            )
                        }
                    }
                }
            } destination: { store in
                switch store.case {
                /// 회원가입
                case let .term(store):
                    TermView(store: store)

                case let .inputId(store):
                    InputIdView(store: store)

                case let .nickname(store):
                    NicknameView(store: store)

                case let .inputProfle(store):
                    ProfileInfoView(store: store)

                case let .inputPhoneNumber(store):
                    AuthenticationView(store: store)

                case let .inputAuthCode(store):
                    EnterAuthCodeView(store: store)

                case let .welcome(store):
                    WelcomeView(store: store)

                /// 더보기
                case let .announce(store):
                    AnnounceView(store: store)

                case let .townPeeps(store):
                    TownPeepsView(store: store)

                case let .notification(store):
                    NotificationView(store: store)

                case let .blockList(store):
                    BlockListView(store: store)

                /// 설정
                case let .setting(store):
                    SettingView(store: store)

                case let .guide(store):
                    GuideView(store: store)

                case let .notificationSetting(store):
                    NotificationSettingView(store: store)

                /// 프로필
                case let .otherProfile(store):
                    OtherProfileView(store: store)

                case let .myProfile(store):
                    MyProfileView(store: store)

                case let .modifyProfile(store):
                    ProfileModifyView(store: store)

                case let .modifyNickname(store):
                    NicknameModifyView(store: store)

                case let .modifyGender(store):
                    ModifyGenderView(store: store)

                /// 업로드
                case let .camera(store):
                    CameraView(store: store)

                case let .edit(store):
                    EditView(store: store)

                case let .write(store):
                    WriteView(store: store)

                /// 핍
                case let .peepDetailList(store):
                    PeepDetailListView(store: store)

                case let .peepDetail(store):
                    PeepDetailView(store: store)
                }
            }
            .overlay {
                if let popUp = store.activePopUp {
                    if popUp == .logout {
                        Color.blur2.ignoresSafeArea()
                    }

                    PopUpAView(
                        popUpType: popUp,
                        onConfirm: { store.send(.popUpConfirmed(popUp)) },
                        onCancel: { store.send(.hidePopUp) }
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RootView(
            store: .init(initialState: RootStore.State()) { RootStore() }
        )
    }
}
