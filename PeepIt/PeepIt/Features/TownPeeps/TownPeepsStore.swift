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
        var size = 5
        var hasNext = true

        var todayStr = ""
        var myTown = ""

        var peepIdList: [Int] = []
    }

    enum Action {
        case backButtonTapped
        case setInitialOffsetY(CGFloat)
        case refresh
        case refreshEnded
        case onAppear
        case peepCellTapped(idx: Int, peepIdList: [Int], page: Int, size: Int)
        case uploadButtonTapped

        /// 내 동네 불러오기
        case getMyTown(TownInfo?)

        /// 동네 핍 조회 api
        case fetchTownPeeps(page: Int, size: Int)
        case fetchTownPeepsResponse(Result<PagedPeeps, Error>)
    }

    @Dependency(\.userProfileStorage) var userProfileStorage
    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .onAppear:
                let formatter = DateFormatter()
                formatter.dateFormat = "M월 d일"
                state.todayStr = formatter.string(from: Date())

                return .merge(
                    .run { send in
                        if let savedProfile = try? await userProfileStorage.load() {
                            await send(.getMyTown(savedProfile.townInfo))
                        }
                    },
                    .run { [size = state.size] send in
                        await send(.fetchTownPeeps(page: 0, size: size))
                    }
                )

            case let .getMyTown(townInfo):
                state.myTown = townInfo?.address ?? ""
                return .none

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case let .setInitialOffsetY(offsetY):
                state.offsetY = offsetY
                return .none

            case .refresh:
                state.isRefreshing = true
                state.page = 0
                state.hasNext = true

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

            case let .fetchTownPeeps(page, size):
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

                    if pagedPeeps.page == 0 {
                        state.peeps = pagedPeeps.content
                        state.peepIdList = pagedPeeps.content.map { $0.id }
                    } else {
                        state.peeps.append(contentsOf: pagedPeeps.content)
                        state.peepIdList.append(contentsOf: pagedPeeps.content.map { $0.id })
                    }

                    state.hasNext = pagedPeeps.hasNext
                    state.page = pagedPeeps.page

                case let .failure(error):
                    guard error.asPeepItError() != .noPeep else { return .none }

                    // TODO: 핍이 없는 경우를 제외한 에러일 때 처리
                }

                /// 새로고침 중이라면 새로고침 끝내기
                guard state.isRefreshing else { return .none }
                return .send(.refreshEnded, animation: .linear)
            }
        }
    }
}
