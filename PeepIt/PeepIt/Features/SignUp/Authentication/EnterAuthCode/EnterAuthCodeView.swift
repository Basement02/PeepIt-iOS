//
//  EnterAuthCodeView.swift
//  PeepIt
//
//  Created by 김민 on 11/15/24.
//

import SwiftUI
import ComposableArchitecture

struct EnterAuthCodeView: View {
    @Perception.Bindable var store: StoreOf<EnterAuthCodeStore>

    @FocusState var focusedField: EnterAuthCodeStore.State.Field?

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                NavigationBar(leadingButton: backButton)
                    .padding(.bottom, 23.adjustedH)

                Group {
                    title
                        .padding(.bottom, 50.adjustedH)

                    enterNumberField
                }
                .padding(.leading, 20.adjustedH)

                Spacer()

                if !store.isAuthSucceed {
                    HStack {
                        Spacer()
                        skipButton
                        Spacer()
                    }
                    .padding(.bottom, 36.adjustedH)
                }
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .bind($store.focusField, to: self.$focusedField)
        }
    }

    private var backButton: some View {
        Button {
            store.send(.backButtonTapped)
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 33.6, height: 33.6)
        }
        .buttonStyle(PressableButtonStyle(originImg: "backN", pressedImg: "backY"))
    }

    private var title: some View {
        Text("010-XXXX-XXXX로\n인증 코드를 전송했어요.")
            .pretendard(.title02)
    }

    private var enterNumberField: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 7) {
                Text("인증 번호")
                    .pretendard(.caption01)
                    .foregroundStyle(Color.white)

                Text("(선택사항)")
                    .pretendard(.caption03)
                    .foregroundStyle(Color.gray300)
            }
            .padding(.bottom, 7)

            HStack(spacing: 6) {
                ForEach(0..<6) { idx in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray500)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        store.isAuthSucceed ? Color.coreLime : Color.clear,
                                        lineWidth: 1
                                    )
                            )

                        TextField("", text: $store.fields[idx])
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .pretendard(.title03)
                            .tint(.clear)
                            .focused(
                                $focusedField,
                                equals: EnterAuthCodeStore.State.Field.allCases[idx]
                            )
                            .foregroundStyle(store.isAuthSucceed ? Color.coreLime : Color.white)

                    }
                    .frame(width: 40, height: 40)
                }
            }

            if store.isAuthSucceed {
                Text("인증이 완료되었습니다.")
                    .pretendard(.caption03)
                    .foregroundStyle(Color.coreLime)
            }
        }
    }

    private var numberField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.gray500)
        }
    }

    private var skipButton: some View {
        NavigationLink(
            state: RootStore.Path.State.welcome(WelcomeStore.State())
        ) {
            Text("건너뛰기")
                .mainGrayButtonStyle()
        }
    }
}

#Preview {
    EnterAuthCodeView(
        store: .init(initialState: EnterAuthCodeStore.State()) { EnterAuthCodeStore()
        }
    )
}
