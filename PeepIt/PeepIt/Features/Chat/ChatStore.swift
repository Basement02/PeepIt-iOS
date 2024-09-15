//
//  ChatStore.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import ComposableArchitecture

@Reducer
struct ChatStore {

    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case closeChatButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .closeChatButtonTapped:
                return .none
            }
        }
    }
}
