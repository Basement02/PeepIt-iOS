//
//  NotificationSettingStore.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct NotificationSettingStore {

    @ObservableState
    struct State: Equatable {

        /// 전체 푸쉬 알림
        var alarmIsOn = false

        /// 핍 알림
        var peepNotiSettings: [PeepNotiType: Bool] = [
            .newChat: false,
            .newReaction: false,
            .pickedHot: false,
            .recommendPeep: false
        ]

        /// 서비스 알림
        var serviceNotiSettings: [ServiceNotiType: Bool] = [
            .newAnnounce: false,
            .others: false,
            .marketing: false
        ]

        /// 핍 알림 enum
        enum PeepNotiType: String, CaseIterable {
            case newChat = "새로운 채팅"
            case newReaction = "새로운 반응"
            case pickedHot = "인기 핍 선정 알림"
            case recommendPeep = "인기 핍 추천"
        }

        /// 서비스 알림 enum
        enum ServiceNotiType: String, CaseIterable {
            case newAnnounce = "새로운 소식"
            case others = "기타(신고 등) 알림"
            case marketing = "마케팅 알림"
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case peepNotiSettingTapped(type: State.PeepNotiType)
        case serviceNotiSettingTapeed(type: State.ServiceNotiType)
        case backButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.alarmIsOn):
                guard !state.alarmIsOn else { return .none }

                state.peepNotiSettings = state.peepNotiSettings.mapValues { _ in false }
                state.serviceNotiSettings = state.serviceNotiSettings.mapValues { _ in false }

                return .none

            case let .peepNotiSettingTapped(type):
                state.peepNotiSettings[type]?.toggle()
                updateAllAlarmToggleButton(&state)

                return .none

            case let .serviceNotiSettingTapeed(type):
                state.serviceNotiSettings[type]?.toggle()
                updateAllAlarmToggleButton(&state)

                return .none

            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }

            default:
                return .none
            }
        }
    }

    private func updateAllAlarmToggleButton(_ state: inout State) {
        state.alarmIsOn = state.peepNotiSettings.values.contains(true) ||
                          state.serviceNotiSettings.values.contains(true)
    }
}
