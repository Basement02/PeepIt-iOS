//
//  PeepDetailStore.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import ComposableArchitecture

@Reducer
struct PeepDetailStore {

    @ObservableState
    struct State: Equatable {
        /// 반응 리스트
        var reactionList = ["a", "b", "c", "d", "e"]

        /// 선택된 반응
        var selectedReaction: String?

        /// 반응 리스트 뷰에 보여주기 여부
        var showReactionList = false

        /// 더보기 메뉴 보여주기 여부
        var showElseMenu = false
    }

    enum Action {
        case setShowingReactionState(Bool)
        case setShowChat(Bool)
        case closeView
        case selectReaction(idx: Int)
        case setShowingElseMenu(Bool)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setShowingReactionState(newState):
                state.showReactionList = newState
                return .none

            case .setShowChat:
                return .none

            case .closeView:
                return .none

            case let .selectReaction(idx):
                state.selectedReaction = state.reactionList[idx]
                return .send(.setShowingReactionState(false))

            case let .setShowingElseMenu(newState):
                state.showElseMenu = newState
                return .none

            default:
                return .none
            }
        }
    }
}
