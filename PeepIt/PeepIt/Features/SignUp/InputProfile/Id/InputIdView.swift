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

                PeepItNavigationBar(leading: backButton)
                    .padding(.bottom, 23.adjustedH)

                Group {
                    title

                    CheckEnterField(
                        store: store.scope(
                            state: \.enterFieldState,
                            action: \.enterFieldAction)
                    )
                    .padding(.top, 50.adjustedH)
                    .frame(width: 285)
                }
                .padding(.leading, 20.adjustedW)

                Spacer()

                if store.idValidation == .validated {
                    nextButton
                        .padding(.bottom, 18.adjustedH)
                }
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                store.send(.onAppeared)
            }
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var title: some View {
        Text("핍잇에 오신 걸 환영해요!\n회원님의 계정을 생성해볼까요?")
            .pretendard(.title02)
    }

    private var nextButton: some View {
        HStack {
            Spacer()

            NavigationLink(
                state: RootStore.Path.State.nickname(NicknameStore.State())
            ) {
                Text("다음")
                    .mainGrayButtonStyle()
            }

            Spacer()
        }
    }
}

#Preview {
    InputIdView(
        store: .init(initialState: InputIdStore.State()) { InputIdStore() }
    )
}
