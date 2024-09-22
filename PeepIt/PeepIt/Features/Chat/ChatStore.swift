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
        var chats: [Chat] = .init()
        var message = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case closeChatButtonTapped
        case loadChats
        case sendButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.message):
                print(state.message)
                return .none

            case .closeChatButtonTapped:
                return .none

            case .loadChats:
                state.chats = [.chatStub1, .chatStub2]
                return .none

            case .sendButtonTapped:
                state.message.removeAll()
                return .none

            case .binding(_):
                return .none
            }
        }
    }
}
