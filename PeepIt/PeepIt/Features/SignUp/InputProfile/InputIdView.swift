//
//  InputIdView.swift
//  PeepIt
//
//  Created by 김민 on 10/7/24.
//

import SwiftUI
import ComposableArchitecture

struct InputIdView: View {
    @Perception.Bindable var store: StoreOf<InputIdStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                Text("핍잇에 오신 걸 환영해요!\n회원님의 계정을 생성해 볼까요?")
                    .font(.system(size: 18))
                    .padding(.bottom, 10)
                    .padding(.top, 48)

                Text("회원님을 식별할 고유 아이디를 만들어 보세요")
                    .font(.system(size: 14))
                    .padding(.bottom, 27)

                TextField("아이디를 입력해 주세요.", text: $store.id)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 10)

                Text(store.idState.message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(
                        store.idState == .base ? .black :
                        store.idState == .validated ? .green : .red
                    )

                Spacer()

                Button {

                } label: {
                    Text("다음")
                }
                .peepItRectangleStyle(
                    backgroundColor: store.idState == .validated
                    ? .black : .gray
                )
                .padding(.bottom, 17)
            }
            .padding(.horizontal, 23)
        }
    }
}

#Preview {
    InputIdView(
        store: .init(initialState: InputIdStore.State()) { InputIdStore() }
    )
}
