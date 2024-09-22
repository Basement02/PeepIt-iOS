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
        var showChat = false
        var chat = ChatStore.State()
    }

    enum Action {
        case setShowingReactionState(Bool)
        case setShowChat(Bool)
        case closeView
        case chat(ChatStore.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.chat, action: \.chat) {
            ChatStore()
        }
        
        Reduce { state, action in
            switch action {
            case let .setShowingReactionState(newState):
                state.showReactionList = newState
                return .none

            case let .setShowChat(newState):
                state.showChat = newState
                return .none

            case .chat(.closeChatButtonTapped):
                state.showChat = false
                return .none

            case .closeView:
                return .none

            default:
                return .none
            }
        }
    }
}
