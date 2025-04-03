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

                PeepItNavigationBar(leading: backButton)
                    .padding(.bottom, 23)

                Group {
                    title
                        .padding(.bottom, 50)

                    enterNumberField
                }
                .padding(.leading, 20)

                Spacer()

                if store.authCodeState != .success {
                    HStack {
                        Spacer()
                        skipButton
                        Spacer()
                    }
                    .padding(.bottom, 36)
                }
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .bind($store.focusField, to: self.$focusedField)
            .onAppear { store.send(.onAppear) }
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
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
                        fieldBackground

                        TextField("", text: $store.fields[idx])
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .pretendard(.title03)
                            .tint(.clear)
                            .focused(
                                $focusedField,
                                equals: EnterAuthCodeStore.State.Field.allCases[idx]
                            )
                            .foregroundStyle(
                                store.authCodeState == .success ? Color.coreLime :
                                    store.authCodeState == .fail ? Color.coreRed :
                                    Color.white
                            )

                    }
                    .frame(width: 40, height: 40)
                }
            }

            Group {
                switch store.authCodeState {
                case .none:
                    let minutes = store.time / 60
                    let seconds = store.time % 60

                    Text(String(format: "남은시간 %02d:%02d", minutes, seconds))
                        .foregroundStyle(Color.coreRed)

                case .success:
                    Text("인증이 완료되었습니다.")
                        .foregroundStyle(Color.coreLime)

                case .fail:
                    Text("코드가 일치하지 않습니다.")
                        .foregroundStyle(Color.coreRed)
                }
            }
            .pretendard(.caption03)
        }
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray500)
            .overlay {
                switch store.authCodeState {
                case .none:
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.clear, lineWidth: 1)
                case .success:
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.coreLime, lineWidth: 1)
                case .fail:
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.coreRed, lineWidth: 1)
                }
            }

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
}

#Preview {
    EnterAuthCodeView(
        store: .init(initialState: EnterAuthCodeStore.State()) { EnterAuthCodeStore()
        }
    )
}
