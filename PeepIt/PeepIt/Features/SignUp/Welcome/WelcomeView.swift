//
//  WelcomeView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    let store: StoreOf<WelcomeStore>

    var body: some View {
        Text("Welcome")
    }
}

#Preview {
    WelcomeView(
        store: .init(initialState: WelcomeStore.State()) { WelcomeStore() }
    )
}
