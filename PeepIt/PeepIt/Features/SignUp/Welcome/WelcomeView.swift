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
        VStack {
            Spacer()

            Text("본인인증 뷰")

            Spacer()

            Button {
                store.send(.goToHomeButtonTapped)
            } label: {
                Text("서비스 홈으로 이동")
            }
            .peepItRectangleStyle()
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    WelcomeView(
        store: .init(initialState: WelcomeStore.State()) { WelcomeStore() }
    )
}
