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
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    Group {
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
            ) { store in
                WithPerceptionTracking {
                    switch store.case {

                        // TODO: 개선
                    case let .login(store):
                        LoginView(store: store)

                    case let .home(store):
                        HomeView(store: store)

                    case let .myProfile(store):
                        MyProfileView(store: store)

                    case let .setting(store):
                        SettingView(store: store)

                    case let .townPeeps(store):
                        TownPeepsView(store: store)

                    case let .notificaiton(store):
                        NotificationView(store: store)

                    case let .announce(store):
                        AnnounceView(store: store)

                    case let .upload(store):
                        UploadView(store: store)

                    case let .profileModify(store):
                        ProfileModifyView(store: store)

                    case let .nicknameModify(store):
                        NicknameModifyView(store: store)

                    case let .genderModify(store):
                        ModifyGenderView(store: store)

                    case let .term(store):
                        TermView(store: store)

                    case let .inputProfile(store):
                        InputProfileView(store: store)

                    case let .inputId(store):
                        InputIdView(store: store)

                    case let .authentication(store):
                        AuthenticationView(store: store)

                    case let .welcome(store):
                        WelcomeView(store: store)
                    }
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
