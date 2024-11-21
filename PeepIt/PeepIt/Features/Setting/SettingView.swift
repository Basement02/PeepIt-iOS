//
//  SettingView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    let store: StoreOf<SettingStore>

    var body: some View {
        ZStack {
            Color.base
                .ignoresSafeArea()

            VStack(spacing: 0) {
                NavigationBar(
                    leadingButton: backButton,
                    title: "설정"
                )
                .padding(.bottom, 39.adjustedH)

                Group {
                    header(title: "서비스")

                    ForEach(
                        Array(zip(SettingStore.State.ServiceTermType.allCases.indices,
                                  SettingStore.State.ServiceTermType.allCases)
                        ), id: \.0
                    ) { idx, item in
                        menuView(title: item.rawValue)
                            .padding(.bottom, idx == SettingStore.State.ServiceTermType.allCases.count-1 ? 0 : 32)
                    }

                    Spacer()
                        .frame(height: 50)

                    header(title: "계정")

                    accountView
                }
                .padding(.horizontal, 29)

                Spacer()
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var backButton: some View {
        BackButton {
            // TODO: 
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

    private var accountView: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 17.6)
                .fill(Color.gray900)
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
            Text("탈퇴하기")
                .pretendard(.caption02)
                .underline()
        }
    }
}

#Preview {
    SettingView(
        store: .init(initialState: SettingStore.State()) { SettingStore() }
    )
}
