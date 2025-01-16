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
        /// 채팅 리스트
        var chats: [Chat] = .init()
        /// 현재 입력 중 메세지
        var message = ""
        /// 본문이 잘렸는지
        var isBodyTrunscated = false
        /// 핍 본문
        var peepBody: Chat = .chatStub4
        /// 채팅 상세 보여주기 여부
        var showChatDetail = false
        /// 상세 보여줄 선택된 채팅
        var selectedChat: Chat? = nil
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 채팅 뷰 등장
        case onAppear
        /// 우측 상단 채팅 버튼 탭
        case closeChatButtonTapped
        /// 현재 입력된 메세지 보내기
        case sendButtonTapped
        /// 본문이 잘렸는지 세팅하기
        case setBodyIsTrunscated
        /// 채팅 롱탭 발생
        case chatLongTapped(chat: Chat)
        /// 채팅 상세 닫기
        case closeChatDetail
        /// 신고 버튼 탭
        case reportButtonTapped
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

            case .sendButtonTapped:
                state.message.removeAll()
                return .none

            case .setBodyIsTrunscated:
                state.isBodyTrunscated = true
                return .none

            case let .chatLongTapped(chat):
                state.showChatDetail = true
                state.selectedChat = chat
                return .none

            case .closeChatDetail:
                state.showChatDetail = false
                state.selectedChat = nil
                return .none

            case .reportButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}
