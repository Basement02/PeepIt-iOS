//
//  SettingView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    let store: StoreOf<SettingStore>

    var body: some View {
        Text("Setting")
    }
}

#Preview {
    SettingView(
        store: .init(initialState: SettingStore.State()) { SettingStore() }
    )
}
