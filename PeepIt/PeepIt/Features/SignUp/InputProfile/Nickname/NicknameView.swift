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
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                PeepItNavigationBar(leading: backButton)
                    .padding(.bottom, 23)

                Group {
                    title

                    CheckEnterField(
                        store: store.scope(
                            state: \.enterFieldState,
                            action: \.enterFieldAction)
                    )
                    .frame(width: 285)
                    .padding(.top, 50)
                }
                .padding(.leading, 20)

                Spacer()

                if store.nicknameValidation == .validated {
                    nextButton
                        .padding(.bottom, 18)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(Color.base)
            .onAppear {
                store.send(.onAppeared)
            }
        }
    }

    private var backButton: some View {
        BackButton { store.send(.backButtonTapped) }
    }

    private var title: some View {
        Text("핍잇에서 어떤 닉네임으로\n불리고 싶나요?")
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
    NicknameView(
        store: .init(initialState: NicknameStore.State()) { NicknameStore() }
    )
}
