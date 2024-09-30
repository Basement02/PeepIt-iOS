//
//  AuthenticationView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct AuthenticationView: View {
    let store: StoreOf<AuthenticationStore>

    var body: some View {
        Text("본인인증")
    }
}

#Preview {
    AuthenticationView(
        store: .init(initialState: AuthenticationStore.State()) { AuthenticationStore() }
    )
}
