//
//  MyProfileStore.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyProfileStore {

    @ObservableState
    struct State: Equatable {
        /// 나의 핍, 나의 활동 탭 선택
        var peepTabSelection = PeepTabType.uploaded

        /// 업로드한 핍들
        var uploadedPeeps: [Peep] = []

        /// 나의 활동 핍들
        var activityPeeps: [Peep] = []

        /// 나의 활동 필터 탭
        var myTabFilter = MyActivityType.all

        enum MyActivityType: String, CaseIterable {
            case all = "전체"
            case chat = "참여한 핍"
            case react = "반응한 핍"
        }
    }

    enum Action {
        case onAppear
        case backButtonTapped
        case modifyButtonTapped
        case peepTabTapped(selection: PeepTabType)
        case myTabTapped(selection: MyProfileStore.State.MyActivityType)
        case loadActivityPeeps
        case uploadButtonTapped
        case watchButtonTapped
        case peepCellTapped(peep: Peep)

        /// api
        case fetchUploadedPeeps(page: Int, size: Int)
        case fetchUploadedPeepsResponse(Result<[Peep], Error>)
    }

    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {

            case .onAppear:
                return .send(.fetchUploadedPeeps(page: 0, size: 10))

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case .modifyButtonTapped:
                return .none

            case let .peepTabTapped(selection):
                state.peepTabSelection = selection

                switch selection {
                case .uploaded:
                    return .none
                case .myActivity:
                    return .send(.loadActivityPeeps)
                }

            case let .myTabTapped(selection):
                state.myTabFilter = selection
                
                return .none

            case .loadActivityPeeps:
                let random = Bool.random()
                if random {
                    state.activityPeeps = [.stubPeep0, .stubPeep1, .stubPeep2, .stubPeep3, .stubPeep4, .stubPeep5, .stubPeep6, .stubPeep7, .stubPeep8, .stubPeep9]
                }
                return .none

            case .uploadButtonTapped:
                return .none

            case .watchButtonTapped:
                return .none

            case .peepCellTapped:
                return .none

            case let .fetchUploadedPeeps(page, size):
                return .run { send in
                    await send(
                        .fetchUploadedPeepsResponse(
                            Result { try await peepAPIClient.fetchUploadedPeeps(page, size) }
                        )
                    )
                }

            case let .fetchUploadedPeepsResponse(result):
                switch result {

                case let .success(peeps):
                    state.uploadedPeeps = peeps
                    return .none

                case .failure:
                    // TODO: 에러 처리
                    return .none
                }
            }
        }
    }
}
