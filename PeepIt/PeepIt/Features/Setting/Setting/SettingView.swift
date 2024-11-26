//
//  SettingView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    @Perception.Bindable var store: StoreOf<SettingStore>

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { proxy in
                WithPerceptionTracking {
                    ZStack(alignment: .bottom) {
                        VStack(spacing: 0) {
                            PeepItNavigationBar(
                                leading: backButton,
                                title: "설정"
                            )
                            .padding(.bottom, 39.adjustedH)

                            Group {
                                header(title: "계정")
                                accountSettingList

                                Spacer()
                                    .frame(height: 50.adjustedH)

                                header(title: "서비스")
                                serviceSettingList
                            }
                            .padding(.horizontal, 29)

                            Spacer()
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .frame(maxWidth: .infinity)
                        .background(Color.base)
                        .toolbar(.hidden, for: .navigationBar)

                        if store.isWithdrawSheetVisible {
                            Color.op
                                .ignoresSafeArea()
                                .onTapGesture {
                                    store.send(.closeSheet)
                                }
                        }

                        WithdrawModal(store: self.store)
                            .frame(maxWidth: .infinity)
                            .frame(height: 775 - proxy.safeAreaInsets.bottom)
                            .background(Color.clear)
                            .offset(y: store.modalOffset)
                            .animation(
                                .easeInOut(duration: 0.3),
                                value: store.isWithdrawSheetVisible
                            )

                    }
                }
            }
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private func header(title: String) -> some View {
        HStack {
            VStack {
                Text(title)
                    .pretendard(.caption01)
                    .foregroundStyle(Color.gray400)
                Spacer()
            }
            Spacer()
        }
        .frame(height: 41)
    }

    private func menuView(title: String) -> some View {
        HStack {
            Text(title)
                .pretendard(.foodnote)
                .padding(.leading, 11)

            Spacer()

            Image("IconInto")
                .resizable()
                .frame(width: 21, height: 21)
        }
        .frame(height: 21)
        .background(Color.base)
    }

    private var accountSettingList: some View {
        VStack(spacing: 32) {
            accountView
            menuView(title: "차단한 계정")
            menuView(title: "탈퇴하기")
                .onTapGesture {
                    store.send(.openWithdrawSheet)
                }
        }
    }

    private var serviceSettingList: some View {
        ForEach(
            Array(zip(SettingStore.State.ServiceTermType.allCases.indices,
                      SettingStore.State.ServiceTermType.allCases)
            ), id: \.0
        ) { idx, item in
            switch item {

            case .mail:
                menuView(title: item.rawValue)

            default:
                if let dest = item.destinationState() {
                    NavigationLink(state: dest) {
                        menuView(title: item.rawValue)
                            .padding(
                                .bottom,
                                idx == SettingStore.State.ServiceTermType.allCases.count - 1 ?
                                0 : 32
                            )
                    }
                    .foregroundStyle(Color.white)
                } else {
                    EmptyView()
                }
            }
        }
    }

    private var accountView: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 17.6)
                .fill(Color.gray400)
                .frame(width: 46, height: 46)

            VStack(alignment: .leading, spacing: 5) {
                Text("sample@sample.com")
                    .pretendard(.body04)
                    .tint(Color.white)

                Text("카카오톡 연동")
                    .pretendard(.caption03)
                    .foregroundStyle(Color.gray400)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray900)
                .frame(height: 71)
        )
        .frame(height: 71)
        .padding(.leading, 11)
    }
}

#Preview {
    NavigationStack {
        SettingView(
            store: .init(initialState: SettingStore.State()) { SettingStore() }
        )
    }
}
