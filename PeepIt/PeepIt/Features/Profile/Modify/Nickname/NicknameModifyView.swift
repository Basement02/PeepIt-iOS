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
                    leading: BackButton { store.send(.backButtonTapped) }
                )
                .padding(.bottom, 23)

                VStack(alignment: .leading, spacing: 50) {
                    HStack {
                        Text("변경할 닉네임을 입력해주세요.")
                            .pretendard(.title02)
                        Spacer()
                    }

                    EnterFieldWithCheck(
                        obj: "닉네임",
                        text: $store.nickname,
                        validState: $store.nicknameEnterState,
                        guideMessage: $store.nicknameMessage
                    )
                    .frame(width: 285)

                    Spacer()
                }
                .padding(.leading, 20)

                if store.nicknameEnterState == .completed {
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
            store.send(.nicknameSaveButtonTapped)
        } label: {
            Text("저장")
                .mainButtonStyle()
                .foregroundStyle(Color.gray800)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .lime))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NicknameModifyView(
        store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
    )
}
