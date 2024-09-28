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
                root: { Color.clear }
            ) { store in
                WithPerceptionTracking {
                    switch store.case {

                    case let .home(store):
                        HomeView(store: store)
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
