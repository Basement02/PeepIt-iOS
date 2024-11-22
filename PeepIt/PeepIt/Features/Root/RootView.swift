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

                /// 설정
                case let .setting(store):
                    SettingView(store: store)

                case let .guide(store):
                    GuideView(store: store)
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
