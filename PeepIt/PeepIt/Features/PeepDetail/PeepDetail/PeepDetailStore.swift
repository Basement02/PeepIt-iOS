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
        var peep: Peep?
        var location = ""

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

        case onAppear
        case backButtonTapped
        case viewTapped
        case elseMenuButtonTapped
        case shareButtonTapped
        case reportButtonTapped
        case chatButtonTapped
        case closeSheet

        /// 개별 핍 api
        case getPeepDetail(id: Int)
        case fetchPeepDetailResponse(Result<Peep, Error>)
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

            case .onAppear:
                return .send(.getPeepDetail(id: state.peepId))

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case .viewTapped:
                state.showElseMenu = false
                return .none

            case .elseMenuButtonTapped:
                state.showElseMenu.toggle()
                return .none

            case .shareButtonTapped:
                state.showElseMenu = false
                state.showShareSheet.toggle()
                return .none

            case .reportButtonTapped:
                state.showElseMenu = false
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

            case let .getPeepDetail(id):
                return .run { send in
                    await send(
                        .fetchPeepDetailResponse(
                            Result { try await peepAPIClient.fetchPeepDetail(id) }
                        )
                    )
                }

            case let .fetchPeepDetailResponse(result):
                switch result {

                case let .success(peep):
                    state.peep = peep
                    state.location = peep.buildingName

                case let .failure(error):
                    print(error)
                }

                return .none

            default:
                return .none
            }
        }
    }
}
