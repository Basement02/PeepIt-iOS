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
