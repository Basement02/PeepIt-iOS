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
                    .padding(.bottom, 23)

                Group {
                    title
                        .padding(.bottom, 50)

                    EnterFieldWithCheck(
                        obj: "아이디",
                        text: $store.id,
                        validState: $store.enterState,
                        guideMessage: $store.guideMessage
                    )
                    .frame(width: 285)
                }
                .padding(.leading, 20)

                Spacer()

                if store.enterState == .completed {
                    nextButton
                        .padding(.bottom, 18)
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

            Button {
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
                    .mainButtonStyle()
                    .foregroundStyle(Color.white)
            }
            .buttonStyle(PressableButtonStyle(colorStyle: .gray900))
            .clipShape(RoundedRectangle(cornerRadius: 16))


            Spacer()
        }
    }
}

#Preview {
    InputIdView(
        store: .init(initialState: InputIdStore.State()) { InputIdStore() }
    )
}
