//
//  NotificationStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct NotificationStore {

    @ObservableState
    struct State: Equatable {
        /// 활성화 핍 리스트
        var activePeeps: [Peep] = []
        /// 알림 리스트
        var notiList: [Notification] = [.stubNoti0, .stubNoti1]
    }

    enum Action {
        case onAppear
        case backButtonTapped
        case removeNoti(item: Notification)
        case uploadButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // TODO: - 디자인 검토 위한 랜덤 함수
                let randomBool = Bool.random()
                if randomBool { state.activePeeps.append(contentsOf: [.stubPeep0, .stubPeep1, .stubPeep2, .stubPeep3]) }
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case let .removeNoti(item):
                state.notiList.removeAll { $0 == item }
                return .none

            case .uploadButtonTapped:
                return .none
            }
        }
    }
}
