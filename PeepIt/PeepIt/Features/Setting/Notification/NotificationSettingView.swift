//
//  NotificationSettingView.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import SwiftUI
import ComposableArchitecture

struct NotificationSettingView: View {
    @Perception.Bindable var store: StoreOf<NotificationSettingStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                PeepItNavigationBar(
                    leading: backButton,
                    title: "알림 설정"
                )
                .padding(.bottom, 39)

                VStack(spacing: 37) {
                    topButton

                    peepNotiSettingList

                    serviceNotiSettingList
                }
                .padding(.horizontal, 29)

                Spacer()
            }
            .background(Color.base)
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var topButton: some View {
        HStack {
            Text("푸쉬 알림")
                .pretendard(.foodnote)

            Toggle("", isOn: $store.alarmIsOn)
                .tint(Color.coreLime)
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray700)
        )
    }

    private func header(title: String) -> some View {
        HStack {
            Text(title)
                .pretendard(.caption01)
                .foregroundStyle(Color.gray400)
            Spacer()
        }
    }

    private var peepNotiSettingList: some View {
        VStack(spacing: 24) {
            header(title: "핍 알림")

            VStack(spacing: 25) {
                ForEach(
                    NotificationSettingStore.State.PeepNotiType.allCases,
                    id: \.self
                ) { type in
                    ToggleMenu(
                        title: type.rawValue,
                        isOn: store.peepNotiSettings[type] ?? false
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.peepNotiSettingTapped(type: type))
                    }
                }
            }
        }
    }

    private var serviceNotiSettingList: some View {
        VStack(spacing: 24) {
            header(title: "서비스 알림")

            VStack(spacing: 25) {
                ForEach(
                    NotificationSettingStore.State.ServiceNotiType.allCases,
                    id: \.self
                ) { type in
                    ToggleMenu(
                        title: type.rawValue,
                        isOn: store.serviceNotiSettings[type] ?? false
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.serviceNotiSettingTapeed(type: type))
                    }
                }
            }
        }
    }
}

fileprivate struct ToggleMenu: View {
    let title: String
    let isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .pretendard(.body04)
            Spacer()
            Image(isOn ? "CheckY" : "CheckN")
                .frame(width: 25.2, height: 25.2)
        }
    }
}

#Preview {
    NotificationSettingView(
        store: .init(initialState: NotificationSettingStore.State()) {
            NotificationSettingStore()
        }
    )
}
