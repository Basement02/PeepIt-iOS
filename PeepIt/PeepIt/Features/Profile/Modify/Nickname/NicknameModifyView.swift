//
//  NicknameModifyView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct NicknameModifyView: View {
    let store: StoreOf<ProfileModifyStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {

                PeepItNavigationBar(
                    leading: BackButton { store.send(.backButtonTapped) }
                )
                .padding(.bottom, 23)

                VStack(alignment: .leading, spacing: 50) {
                    HStack {
                        Text("변경할 닉네임을 입력해주세요.")
                            .pretendard(.title02)
                        Spacer()
                    }

                    CheckEnterField(
                        store: store.scope(
                            state: \.enterFieldState,
                            action: \.enterFieldAction)
                    )
                    .frame(width: 285)

                    Spacer()
                }
                .padding(.leading, 20)

                if store.nicknameValidation == .validated {
                    saveButton
                        .padding(.bottom, 18)
                }
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { store.send(.onAppear) }
        }
    }

    private var saveButton: some View {
        Button {
            store.send(.saveButtonTapped)
        } label: {
            Text("저장")
                .mainLimeButtonStyle()
        }
    }
}

#Preview {
    NicknameModifyView(
        store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
    )
}
