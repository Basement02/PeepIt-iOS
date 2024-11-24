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
    }

    enum Action {
        case elseButtonTapped(_ newState: Bool)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case let .elseButtonTapped(newState):
                state.isElseButtonTapped = newState

                return .none
            }
        }
    }
}
