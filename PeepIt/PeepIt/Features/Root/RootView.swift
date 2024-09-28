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
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {

                Group {
                    switch store.authState {
                    case .authorized:
                        HomeView(store: store.scope(state: \.home, action: \.home))

                    case .notRegistered, .registered:
                        Text("Onboarding")
                    }
                }

            } destination: { store in
                EmptyView()
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
