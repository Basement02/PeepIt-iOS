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
            VStack(spacing: 0) {

                HStack {
                    Text("닉네임")
                        .font(.system(size: 12))
                    Spacer()
                }
                .padding(.top, 41)
                .padding(.bottom, 15)

                TextField("", text: $store.nicknameField)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                    )

                Spacer()

                modifyButton
                    .padding(.bottom, 17)
            }
            .padding(.horizontal, 20)
        }
    }

    private var modifyButton: some View {
        Button {

        } label: {
            Text("저장")
        }
        .peepItRectangleStyle()
    }
}

#Preview {
    NicknameModifyView(
        store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
    )
}
