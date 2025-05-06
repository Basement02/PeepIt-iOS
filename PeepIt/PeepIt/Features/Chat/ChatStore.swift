//
//  ChatStore.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import ComposableArchitecture
import UIKit

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
        /// 채팅 전송 여부
        var isChatSent: Bool? = nil

        /// 신고 상태 관리
        var report = ReportStore.State()
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
        /// 채팅 더보기 탭
        case showMoreButtonTapped(chat: Chat)
        /// 채팅 상세 열기
        case showChatDetail(chat: Chat)
        /// 채팅 상세 닫기
        case closeChatDetail
        /// 신고 버튼 탭
        case reportButtonTapped
        /// 입력 메세지 줄 초과 체크
        case checkIfEnterMessageLong(lineCount: Int)
        /// 신고 액션 처리
        case report(ReportStore.Action)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.report, action: \.report) {
            ReportStore()
        }

        Reduce { state, action in
            switch action {

            case .onAppear:
                let stubChats: [Chat] = [.chatStub1, .chatStub2, .chatStub3, .chatStub5, .chatStub6 , .chatStub7, .chatStub8]
                state.chats = stubChats
                return .none

            case .binding(\.message):
                let maxCount = 500

                if state.message.count > maxCount {
                    state.message = String(state.message.prefix(maxCount))
                    return .none
                }

                return .none

            case .closeChatButtonTapped:
                return .none

            case .sendButtonTapped:
                let newChat: Chat = .init(
                    id: UUID().uuidString,
                    user: .stubUser1,
                    message: state.message,
                    sendTime: "5분 전",
                    type: .mine
                )

                state.chats.append(newChat)
                state.message.removeAll()
                state.isChatSent = true

                return .none

            case .setBodyIsTrunscated:
                state.isBodyTrunscated = true
                return .none

            case let .chatLongTapped(chat),
                let .showMoreButtonTapped(chat):
                return .send(.showChatDetail(chat: chat))

            case let .showChatDetail(chat):
                state.showChatDetail = true
                state.selectedChat = chat
                return .none

            case .closeChatDetail:
                state.showChatDetail = false
                state.selectedChat = nil
                return .none

            case .reportButtonTapped:
                return .send(.report(.openModal))

            case let .checkIfEnterMessageLong(lineCount):
                guard lineCount >= 25 else { return .none }
                state.message = String((state.message.prefix(state.message.count - 1)))

                return .none

            default:
                return .none
            }
        }
    }
}
