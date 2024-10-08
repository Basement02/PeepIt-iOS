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

    @FocusState var focused: AuthenticationStore.State.CodeField?

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                Text("휴대폰 번호를 인증하고\n핍잇의 모든 기능을 사용해 보세요.")
                    .font(.system(size: 18))
                    .padding(.top, 48)
                    .padding(.bottom, 54)

                if store.isSMSAuthProcess {
                    HStack {
                        Text(store.phoneNumber)
                            .background(Color.init(uiColor: .systemGray4))
                            .onTapGesture {
                                store.send(.phoneNumberLabelTapped)
                            }
                        Text("로 인증 코드를 전송했어요.")
                    }
                    .padding(.bottom, 25)


                    codeTextField
                        .padding(.bottom, 15)

                    Text("코드가 일치하지 않습니다.")
                        .padding(.bottom, 27)

                    resendButton

                    Spacer()

                    skipButton
                        .padding(.bottom, 17)

                } else {
                    TextField("010-XXXX-XXXX", text: $store.phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)

                    Spacer()

                    bottomButton
                        .padding(.bottom, 17)
                }

            }
            .padding(.horizontal, 23)
        }
    }

    private var skipButton: some View {
        Button {
            store.send(.bottomButtonTapped(isStartAuthButton: false))
        } label: {
            Text("건너뛰기")
        }
        .peepItRectangleStyle()
    }

    private var bottomButton: some View {
        Button {
            store.send(.bottomButtonTapped(isStartAuthButton: store.isAuthProcessReady))
        } label: {
            Text(store.isAuthProcessReady ? "인증하기" : "건너뛰기")
        }
        .peepItRectangleStyle()
    }

    private var codeTextField: some View {
        HStack(spacing: 16) {
            WithPerceptionTracking {
                ForEach(0..<6) { idx in
                    NumberTextFieldView(number: $store.code[idx])
                        .focused(
                            $focused,
                            equals: AuthenticationStore.State.CodeField(rawValue: idx)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 53)
    }

    private var resendButton: some View {
        HStack {
            Spacer()
            Button {
                store.send(.resendCodeButtonTapped)
            } label: {
                Text("코드를 받지 못하였어요.")
            }
            Spacer()
        }
    }
}

fileprivate struct NumberTextFieldView: View {
    @Binding var number: String

    var body: some View {
        TextField("", text: $number)
            .keyboardType(.numberPad)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black, lineWidth: 1.0)
                    .frame(height: 53)
            )
    }
}

#Preview {
    AuthenticationView(
        store: .init(initialState: AuthenticationStore.State()) { AuthenticationStore() }
    )
}
