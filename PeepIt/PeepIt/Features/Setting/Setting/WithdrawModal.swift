//
//  WithdrawModal.swift
//  PeepIt
//
//  Created by 김민 on 11/25/24.
//

import SwiftUI
import ComposableArchitecture

struct WithdrawModal: View {
    @Perception.Bindable var store: StoreOf<SettingStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Text("hi")
            }
            .onTapGesture {
                store.send(.closeSheet)
            }
        }
    }

    private var slideBar: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.gray600)
            .frame(width: 60, height: 5)
    }

    private var title: some View {
        HStack {
            Text(
                """
                어떤 점에서
                서비스가 더 이상
                필요 없다고 느끼셨나요?
                """
            )
            .pretendard(.title02)

            Spacer()
        }
    }

    private var description: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("탈퇴 시 유의사항")
                    .pretendard(.caption02)
                    .padding(.bottom, 10)

                Group {
                    Text(" · 회원 탈퇴 요청 후 7일 이내에 재로그인 시 탈퇴 요청이 철회됩니다")
                    Text(" · 회원 탈퇴 요청 후 7일 이후 회원 탈퇴가 이루어지며, 이때 회원 계정")
                    Text("   과 모든 기록은 요청 날짜로부터 3개월 간 보관 후 영구적으로 삭제\n  됩니다.")
                    Text(" · 삭제된 데이터는 다시 복구가 불가능합니다.")
                    Text(" · 탈퇴 후 동일 아이디로 3개월간 가입이 불가능합니다.")
                }
                .pretendard(.caption04)
            }
            .foregroundStyle(Color.gray400)

            Spacer()
        }
    }

    private var enterField: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("유의사항에 모두 동의한다면, 다음 문구를 따라 입력해주세요.")
                    .pretendard(.caption02)
                    .padding(.bottom, 10)

                ZStack(alignment: .leading) {
                    Text("서비스 탈퇴에 동의합니다.")
                        .foregroundStyle(Color.gray400)
                    TextField("", text: $store.withdrawMessage)
                        .tint(Color.coreLime)
                }
                .pretendard(.body02)
                .frame(height: 29)

                Rectangle()
                    .frame(height: 1)
            }
            .frame(width: 285)

            Spacer()
        }
    }

    private var bottom: some View {
        VStack(spacing: 16) {
            Button {
                // TODO:
            } label: {
                Text("탈퇴하기")
            }
            .mainGrayButtonStyle()
            .opacity(store.isWithdrawActivated ? 1 : 0)

            Button {
                store.send(.closeSheet)
            } label: {
                Rectangle()
                    .frame(width: 250, height: 20)
                    .opacity(0)
            }
            .buttonStyle(
                PressableViewButtonStyle(
                    normalView: Text("취소"),
                    pressedView: Text("취소").foregroundStyle(Color.gray300)
                )
            )
            .pretendard(.body04 )
        }
        .frame(height: 91)
    }

    private var withdrawOptionList: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(
                SettingStore.State.WithdrawType.allCases,
                id: \.self
            ) { type in
                withdrawOption(
                    of: type,
                    isSelected: type == store.selectedWithdrawType
                )
                .onTapGesture {
                    store.send(.selectWithdrawType(type: type))
                }
            }

            if store.selectedWithdrawType == .write {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray600)

                    if store.withdrawReason.isEmpty
                        && !store.isTextEditorFocused {
                        Text("예시 문구를 입력해주세요.")
                            .pretendard(.body05)
                            .foregroundStyle(Color.gray300)
                            .padding(.top, 18)
                            .padding(.horizontal, 18)
                    }

                    TextEditor(text: $store.withdrawReason)
                        .pretendard(.body05)
                        .tint(Color.coreLime)
                        .scrollContentBackground(.hidden)
                        .padding(.all, 18)
                }
                .frame(width: 301, height: 142)
                .onTapGesture {
                    store.send(.textEditorTapped)
                }
            }
        }
    }

    private func withdrawOption(
        of type: SettingStore.State.WithdrawType,
        isSelected: Bool?
    ) -> some View {
        HStack(spacing: 9) {
            ZStack {
                Circle()
                    .strokeBorder(Color.white, lineWidth: 0.84)
                    .frame(width: 14.28, height: 14.28)

                if let isSelected = isSelected, isSelected {
                    Circle()
                        .fill(Color.coreLime)
                        .frame(width: 9, height: 9)
                }
            }

            Text(type.rawValue)
                .pretendard(.body04)
            Spacer()
        }
        .frame(height: 20)
    }
}

#Preview {
    NavigationStack {
        SettingView(
            store: .init(initialState: SettingStore.State()) { SettingStore() }
        )
    }
}
