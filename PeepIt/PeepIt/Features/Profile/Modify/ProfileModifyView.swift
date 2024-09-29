//
//  ProfileModifyView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct ProfileModifyView: View {
    let store: StoreOf<ProfileModifyStore>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileModifyView(
        store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
    )
}
