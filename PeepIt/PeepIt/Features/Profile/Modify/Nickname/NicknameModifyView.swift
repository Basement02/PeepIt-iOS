//
//  NicknameModifyView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct NicknameModifyView: View {
    @Perception.Bindable var store: StoreOf<ProfileModifyStore>

    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("닉네임")
            }
        }
    }
}

#Preview {
    NicknameModifyView(
        store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
    )
}
