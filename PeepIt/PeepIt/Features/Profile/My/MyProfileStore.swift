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

        /// 나의 활동 핍들
        var activityPeeps: [Peep] = []

        /// 나의 활동 필터 탭
        var myTabFilter = MyActivityType.all

        enum MyActivityType: String, CaseIterable {
            case all = "전체"
            case chat = "참여한 핍"
            case react = "반응한 핍"
        }

        /// 업로드한 핍 관리
        var uploadedPeeps: [Peep] = []
        var uploadedPeepPage = 0
        var uploadedPeepHasNext = true

        /// 핍 페이지네이션 사이즈
        var size = 15
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

        /// 사용자가 업로드한 핍 조회 API
        case fetchUploadedPeeps
        case fetchUploadedPeepsResponse(Result<PagedPeeps, Error>)
    }

    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {

            case .onAppear:
                state.uploadedPeepPage = 0
                state.uploadedPeepHasNext = true
                return .send(.fetchUploadedPeeps)

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case .modifyButtonTapped:
                return .none

            case let .peepTabTapped(selection):
                state.peepTabSelection = selection

                switch selection {
                case .uploaded:
                    state.uploadedPeepPage = 0
                    state.uploadedPeepHasNext = true
                    state.uploadedPeeps = .init()
                    return .send(.fetchUploadedPeeps)
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

            case .fetchUploadedPeeps:
                let page = state.uploadedPeepPage
                let size = state.size

                return .run { send in
                    await send(
                        .fetchUploadedPeepsResponse(
                            Result { try await peepAPIClient.fetchUploadedPeeps(page, size) }
                        )
                    )
                }

            case let .fetchUploadedPeepsResponse(result):
                switch result {

                case let .success(pagedPeeps):
                    state.uploadedPeeps.append(contentsOf: pagedPeeps.content)
                    state.uploadedPeepHasNext = pagedPeeps.hasNext
                    state.uploadedPeepPage += 1
                    return .none

                case .failure:
                    // TODO: 에러 처리
                    return .none
                }
            }
        }
    }
}
