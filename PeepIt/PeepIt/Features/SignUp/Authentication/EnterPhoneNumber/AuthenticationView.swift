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
            VStack(alignment: .leading, spacing: 0) {
                PeepItNavigationBar(leading: backButton)
                    .padding(.bottom, 23.adjustedH)

                Group {
                    title

                    phoneNumberTextField
                        .padding(.top, 50.adjustedH)
                }
                .padding(.leading, 20.adjustedW)

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
                .padding(.bottom, 36.adjustedH)
            }
            .background(Color.base)
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
        NavigationLink(
            state: RootStore.Path.State.welcome(WelcomeStore.State())
        ) {
            Text("건너뛰기")
                .mainGrayButtonStyle()
        }
    }

    private var nextButton: some View {
        NavigationLink(
            state: RootStore.Path.State.inputAuthCode(EnterAuthCodeStore.State())
        ) {
            Text("인증하기")
                .mainLimeButtonStyle()
        }
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
