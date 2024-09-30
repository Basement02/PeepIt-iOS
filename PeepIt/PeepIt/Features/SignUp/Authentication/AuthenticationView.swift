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
        VStack {
            Spacer()

            Text("본인인증 뷰")

            Spacer()

            Button {
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .peepItRectangleStyle()
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    AuthenticationView(
        store: .init(initialState: AuthenticationStore.State()) { AuthenticationStore() }
    )
}
