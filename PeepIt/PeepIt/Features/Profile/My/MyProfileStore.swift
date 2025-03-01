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
        case loadUploadedPeeps
        case loadActivityPeeps
        case uploadButtonTapped
        case watchButtonTapped
        case peepCellTapped(peep: Peep)
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {

            case .onAppear:
                return .send(.loadUploadedPeeps)

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case .modifyButtonTapped:
                return .none

            case let .peepTabTapped(selection):
                state.peepTabSelection = selection

                switch selection {
                case .uploaded:
                    return .send(.loadUploadedPeeps)
                case .myActivity:
                    return .send(.loadActivityPeeps)
                }

            case let .myTabTapped(selection):
                state.myTabFilter = selection
                
                return .none

            case .loadUploadedPeeps:
                let random = Bool.random()
                if random {
                    state.uploadedPeeps = [.stubPeep2, .stubPeep3, .stubPeep4, .stubPeep5, .stubPeep6, .stubPeep7, .stubPeep8, .stubPeep9, .stubPeep10, .stubPeep11]
                }
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
            }
        }
    }
}
