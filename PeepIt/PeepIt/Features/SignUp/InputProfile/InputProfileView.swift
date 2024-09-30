//
//  InputProfileView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct InputProfileView: View {
    let store: StoreOf<InputProfileStore>

    var body: some View {
        VStack {
            Spacer()

            Text("정보 입력")
            
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
    InputProfileView(
        store: .init(initialState: InputProfileStore.State()) { InputProfileStore() }
    )
}
