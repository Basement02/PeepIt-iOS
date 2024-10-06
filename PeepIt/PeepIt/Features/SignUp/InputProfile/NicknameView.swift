//
//  NicknameView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct NicknameView: View {
    @Perception.Bindable var store: StoreOf<NicknameStore>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("핍잇에서 어떤 닉네임으로\n불리고 싶나요?")
                .font(.system(size: 18))
                .padding(.bottom, 54)
                .padding(.top, 48)

            TextField("닉네임을 입력해 주세요.", text: $store.nickname)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 10)

            Text(store.validState.message)
                .font(.system(size: 12))

            Spacer()


            Button {
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .peepItRectangleStyle(
                backgroundColor: store.validState == .validated ? .black : .gray
            )
            .padding(.bottom, 17)
        }
        .padding(.horizontal, 23)
    }
}

#Preview {
    NicknameView(
        store: .init(initialState: NicknameStore.State()) { NicknameStore() }
    )
}
