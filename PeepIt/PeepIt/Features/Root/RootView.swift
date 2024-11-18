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
