//
//  TownPeepsStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TownPeepsStore {

    @ObservableState
    struct State: Equatable {
        var offsetY = CGFloat.zero
        var isRefreshing = false
        var rotateAngle = Double.zero
        var peeps: [Peep] = []

        var page = 0
        var size = 10
        var hasNext = true
    }

    enum Action {
        case backButtonTapped
        case setInitialOffsetY(CGFloat)
        case refresh
        case refreshEnded
        case onAppear
        case peepCellTapped(idx: Int, peeps: [Peep])
        case uploadButtonTapped

        /// 동네 핍 조회 api
        case fetchTownPeeps
        case fetchTownPeepsResponse(Result<PagedPeeps, Error>)
    }

    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchTownPeeps)

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case let .setInitialOffsetY(offsetY):
                state.offsetY = offsetY
                return .none

            case .refresh:
                state.isRefreshing = true
                state.page = 0
                state.hasNext = true
                state.peeps.removeAll()

                let (page, size) = (state.page, state.size)

                return .run { send in
                    let result = await Result { try await peepAPIClient.fetchTownPeeps(page, size) }
                    await send(.fetchTownPeepsResponse(result))
                }

            case .refreshEnded:
                state.isRefreshing = false
                return .none

            case .peepCellTapped, .uploadButtonTapped:
                return .none

            case .fetchTownPeeps:
                let (page, size) = (state.page, state.size)

                return .run { send in
                    await send(
                        .fetchTownPeepsResponse(
                            Result { try await peepAPIClient.fetchTownPeeps(page, size) }
                        )
                    )
                }

            case let .fetchTownPeepsResponse(result):
                switch result {
                case let .success(pagedPeeps):
                    state.peeps.append(contentsOf: pagedPeeps.content)
                    state.hasNext = pagedPeeps.hasNext
                    state.page += 1

                case let .failure(error):
                    // TODO: - 에러 처리
                    print(error)
                }

                /// 새로고침 중이라면 새로고침 끝내기
                guard state.isRefreshing else { return .none }
                return .send(.refreshEnded, animation: .linear)
            }
        }
    }
}
