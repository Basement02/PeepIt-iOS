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

                PeepItNavigationBar(
                    leading: DismissButton { store.send(.backButtonTapped) }
                )
                .padding(.bottom, 23)

                VStack(alignment: .leading, spacing: 50) {
                    HStack {
                        Text("변경할 닉네임을 입력해주세요.")
                            .pretendard(.title02)
                            .padding(.bottom, 50)
                        Spacer()
                    }

                    Spacer()
                }
                .padding(.leading, 20)

                saveButton
                    .padding(.bottom, 18)
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var saveButton: some View {
        Button {

        } label: {
            Text("저장")
                .mainGrayButtonStyle()
        }
    }
}

#Preview {
    NicknameModifyView(
        store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
    )
}
