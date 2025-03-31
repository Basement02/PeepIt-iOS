//
//  AuthenticationView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct AuthenticationView: View {
    @Perception.Bindable var store: StoreOf<AuthenticationStore>

    @FocusState var isFocused: Bool

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                PeepItNavigationBar(leading: backButton)
                    .padding(.bottom, 23)

                HStack {
                    VStack(alignment: .leading, spacing: 50) {
                        title
                        phoneNumberTextField
                    }
                    Spacer()
                }
                .padding(.leading, 20)

                Spacer()

                Group {
                    if store.phoneNumberValid == .valid {
                        HStack {
                            Spacer()
                            nextButton
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            skipButton
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 36)
            }
            .background(Color.base)
            .overlay {
                if store.isDuplicated {
                    PopUpBView(
                        title: "이미 사용 중인 번호입니다.",
                        description: "입력된 전화번호가 올바른지 다시 한 번 확인해주세요.",
                        buttonLabel: "네",
                        action: { store.send(.popButtonTapped) }
                    )
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                isFocused = true
            }
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var title: some View {
        Text("휴대폰 번호를 인증하고\n모든 기능을 사용해보세요.")
            .pretendard(.title02)
    }

    private var skipButton: some View {
        Button {
            store.send(.skipButtonTapped)
        } label: {
            Text("건너뛰기")
                .mainButtonStyle()
                .foregroundStyle(Color.white)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .gray900))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var nextButton: some View {
        Button {
            store.send(.nextButtonTapped)
        } label: {
            Text("인증하기")
                .mainButtonStyle()
                .foregroundStyle(Color.gray800)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .lime))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var phoneNumberTextField: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 7) {
                Text("휴대폰 번호")
                    .pretendard(.caption01)
                    .foregroundStyle(Color.white)

                Text("(선택사항)")
                    .pretendard(.caption03)
                    .foregroundStyle(Color.gray300)
            }
            .padding(.bottom, 20)

            Group {
                TextField("010XXXXXXXX", text: $store.phoneNumber)
                    .focused($isFocused)
                    .pretendard(.body02)
                    .keyboardType(.numberPad)
                    .foregroundStyle(Color.white)
                    .tint(Color.coreLime)
                    .frame(height: 29.4)

                Rectangle()
                    .foregroundStyle(
                        store.phoneNumberValid == .formatError
                        ? Color.coreRed : Color.white
                    )
                    .frame(height: 1)
                    .padding(.top, 10)
            }
            .frame(width: 285)

            Text(store.phoneNumberValid.message)
                .pretendard(.caption03)
                .foregroundStyle(
                    store.phoneNumberValid == .formatError
                    ? Color.coreRed : Color.gray100
                )
                .padding(.top, 10)
        }
    }
}
#Preview {
    AuthenticationView(
        store: .init(initialState: AuthenticationStore.State()) { AuthenticationStore() }
    )
}
