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
        /// 활성화 핍 리스트 관리
        var activePeeps: [Peep] = []
        var page = 0
        var size = 15
        var hasNext = true

        /// 알림 리스트
        var notiList: [Notification] = [.stubNoti0, .stubNoti1]
    }

    enum Action {
        case onAppear
        case backButtonTapped
        case removeNoti(item: Notification)
        case uploadButtonTapped
        case activePeepCellTapped(selectedPeep: Peep)

        /// 활성화 핍 API
        case fetchActivePeeps
        case fetchActivePeepResponse(Result<PagedPeeps, Error>)
    }

    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchActivePeeps)

            case .backButtonTapped:
                return .run { _ in await dismiss() }

            case let .removeNoti(item):
                state.notiList.removeAll { $0 == item }
                return .none

            case .uploadButtonTapped, .activePeepCellTapped:
                return .none

            case .fetchActivePeeps:
                let (page, size) = (state.page, state.size)

                return .run { send in
                    await send(
                        .fetchActivePeepResponse(
                            Result { try await peepAPIClient.fetchUserActivePeeps(page, size) }
                        )
                    )
                }

            case let .fetchActivePeepResponse(result):
                switch result {
                case let .success(pagedPeeps):
                    state.activePeeps.append(contentsOf: pagedPeeps.content)
                    state.hasNext = pagedPeeps.hasNext
                    state.page += 1
                    return .none

                case .failure:
                    // TODO: 
                    return .none
                }
            }
        }
    }
}
