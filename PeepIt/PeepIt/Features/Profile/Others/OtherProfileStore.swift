//
//  OtherProfileStore.swift
//  PeepIt
//
//  Created by 김민 on 9/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OtherProfileStore {

    @ObservableState
    struct State: Equatable {
        /// 핍 리스트
        var uploadedPeeps: [Peep] = [.stubPeep0, .stubPeep1, .stubPeep2, .stubPeep3]
        /// 상단 우측 더보기 버튼 탭 여부
        var isElseButtonTapped = false
        /// 유저 차단 여부
        var isUserBlocked = false
    }

    enum Action {
        /// 뷰 나타날 때
        case onAppear
        /// 더보기 버튼 탭했을 때
        case elseButtonTapped(_ newState: Bool)
        /// 뒤로가기 버튼 탭했을 때
        case backButtonTapped
        /// 차단 관련 버튼 탭했을 때
        case blockButtonTapped
        /// 현재 유저 차단하기
        case blockUser
        /// 현재 유저 차단 해제하기
        case unblockUser
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // TODO: 차단 여부 로드
                return .none

            case let .elseButtonTapped(newState):
                state.isElseButtonTapped = newState
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }

            case .blockButtonTapped:
                if state.isUserBlocked {
                    return .send(.unblockUser)
                } else {
                    return .send(.blockUser)
                }

            case .blockUser:
                // TODO: 차단 api 호출
                state.isUserBlocked = true
                state.isElseButtonTapped = false
                return .none

            case .unblockUser:
                // TODO: 차단 해제 api 호출
                state.isUserBlocked = false
                state.isElseButtonTapped = false
                return .none
            }
        }
    }
}
