//
//  ReactionListStore.swift
//  PeepIt
//
//  Created by 김민 on 5/7/25.
//

import ComposableArchitecture

@Reducer
struct ReactionListStore {

    @ObservableState
    struct State: Equatable {
        var reactionList = ReactionType.allCases
        var selectedReaction: ReactionType?

        // TODO: 이모티콘 추후 수정
        enum ReactionType: String, CaseIterable {
            case a = "😀"
            case b = "😥"
            case c = "🤔"
            case d = "😙"
            case e = "😍"
        }

        var showReactionList = false
        var showingReactionIdx = 0
    }

    enum Action {
        case onAppear
        case initReactionButtonTapped
        case selectReaction(selectedReaction: State.ReactionType)
        case unselectReaction

        /// 타이머
        case setTimer
        case timerTicked
        case stopTimer
    }

    enum CancelId {
        case timer
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .onAppear:
                return .send(.setTimer)

            case .initReactionButtonTapped:
                state.showReactionList = true
                return .none

            case let .selectReaction(selectedReaction):
                state.selectedReaction = selectedReaction
                state.showReactionList = false
                return .none

            case .unselectReaction:
                state.selectedReaction = nil
                state.showReactionList = false
                return .none

            case .setTimer:
                guard state.selectedReaction == nil else { return .none }
                
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(0.75))
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelId.timer)

            case .timerTicked:
                state.showingReactionIdx = (state.showingReactionIdx + 1) % state.reactionList.count
                return .none

            case .stopTimer:
                return .cancel(id: CancelId.timer)
            }
        }
    }
}
