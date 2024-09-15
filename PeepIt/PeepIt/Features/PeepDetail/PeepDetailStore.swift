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
        var showReactionList = false
    }

    enum Action {
        case setShowingReactionState(Bool)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setShowingReactionState(newState):
                state.showReactionList = newState
                return .none
            }
        }
    }
}
