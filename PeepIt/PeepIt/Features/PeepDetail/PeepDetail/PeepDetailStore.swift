//
//  PeepDetailStore.swift
//  PeepIt
//
//  Created by 김민 on 5/6/25.
//

import ComposableArchitecture

@Reducer
struct PeepDetailStore {

    @ObservableState
    struct State: Equatable {
        var report = ReportStore.State()
        var chat = ChatStore.State()
        var reaction = ReactionListStore.State()

        var isMine = true
        var peepId = 0
        var showElseMenu = false
        var showChat = false
        var showShareSheet = false
        var showReportSheet = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case report(ReportStore.Action)
        case chat(ChatStore.Action)
        case reaction(ReactionListStore.Action)

        case backButtonTapped
        case viewTapped
        case elseMenuButtonTapped
        case shareButtonTapped
        case reportButtonTapped
        case chatButtonTapped
        case closeSheet
    }

    enum CancelId {
        case timer
    }

    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.report, action: \.report) {
            ReportStore()
        }

        Scope(state: \.chat, action: \.chat) {
            ChatStore()
        }

        Scope(state: \.reaction, action: \.reaction) {
            ReactionListStore()
        }

        Reduce { state, action in
            switch action {

            case .binding(\.showShareSheet):
                return .none

            case .backButtonTapped:
                return .none

            case .viewTapped:
                state.showElseMenu = false
                return .none

            case .elseMenuButtonTapped:
                state.showElseMenu.toggle()
                return .none

            case .shareButtonTapped:
                state.showShareSheet.toggle()
                return .none

            case .reportButtonTapped:
                state.showReportSheet = true
                return .send(.report(.openModal))

            case .chatButtonTapped:
                state.showChat = true
                return .none

            case .chat(.closeChatButtonTapped):
                state.showChat = false
                return .none

            case .closeSheet:
                state.showReportSheet = false
                return .none

            default:
                return .none
            }
        }
    }
}
