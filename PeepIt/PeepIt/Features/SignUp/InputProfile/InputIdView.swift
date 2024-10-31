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

                NavigationBar(leadingButton: backButton)
                    .padding(.bottom, 23.adjustedH)

                Group {
                    title

                    CheckEnterField(
                        store: store.scope(
                            state: \.enterFieldState,
                            action: \.enterFieldAction)
                    )
                    .padding(.top, 50.adjustedH)
                    .padding(.trailing, 88.adjustedW)
                }
                .padding(.leading, 20.adjustedW)

                Spacer()

                nextButton
                    .padding(.bottom, 84.adjustedH)
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                store.send(.onAppeared)
            }
        }
    }

    private var backButton: some View {
        Button {
            store.send(.backButtonTapped)
        } label: {
            Image("backN")
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
            }
            .mainbuttonStyle(store.nextButtonEnabled)
            .disabled(!store.nextButtonEnabled)

            Spacer()
        }
    }
}

#Preview {
    InputIdView(
        store: .init(initialState: InputIdStore.State()) { InputIdStore() }
    )
}
