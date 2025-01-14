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
        var isBodyTrunscated = false
        var peepBody: Chat = .chatStub4
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case closeChatButtonTapped
        case loadChats
        case sendButtonTapped
        case setBodyIsTrunscated
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {

            case .onAppear:
                let stubChats: [Chat] = [.chatStub1, .chatStub2, .chatStub3, .chatStub4, .chatStub5, .chatStub6]
                state.chats.append(contentsOf: stubChats)
                return .none

            case .binding(\.message):
                return .none

            case .closeChatButtonTapped:
                return .none

            case .loadChats:
                state.chats = [.chatStub1, .chatStub2]
                return .none

            case .sendButtonTapped:
                state.message.removeAll()
                return .none

            case .setBodyIsTrunscated:
                state.isBodyTrunscated = true
                return .none

            default:
                return .none
            }
        }
    }
}
