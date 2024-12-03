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
        /// 반응 리스트
        var reactionList = ["a", "b", "c", "d", "e"]

        /// 선택된 반응
        var selectedReaction: String?

        /// 반응 리스트 뷰에 보여주기 여부
        var showReactionList = false

        /// 더보기 메뉴 보여주기 여부
        var showElseMenu = false

        /// 차단 모달 보여주기 여부
        var isReportSheetVisible = false

        /// 차단 모달 offset 관련
        var modalOffset = Constant.screenHeight

        /// 신고 모달 관련
        var report = ReportStore.State()
    }

    enum Action {
        /// 반응 리스트 보여주기
        case setShowingReactionState(Bool)

        /// 채팅 뷰 보여주기
        case setShowChat(Bool)

        /// 뒤로 가기
        case closeView

        /// 반응 선택
        case selectReaction(idx: Int)

        /// 더보기 메뉴 보여주기 여부
        case setShowingElseMenu(Bool)

        /// 더보기 메뉴 - 신고 버튼 탭
        case reportButtonTapped

        /// 신고 모달 열기
        case openReportSheet

        /// 신고 모달 닫기
        case closeReportSheet

        /// 신고 모달 관련
        case report(ReportStore.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.report, action: \.report) {
            ReportStore()
        }

        Reduce { state, action in
            switch action {

            case let .setShowingReactionState(newState):
                state.showReactionList = newState
                return .none

            case .setShowChat:
                return .none

            case .closeView:
                return .none

            case let .selectReaction(idx):
                state.selectedReaction = state.reactionList[idx]
                return .send(.setShowingReactionState(false))

            case let .setShowingElseMenu(newState):
                state.showElseMenu = newState
                return .none

            case .openReportSheet:
                state.isReportSheetVisible = true
                state.modalOffset = 0
                return .none

            case .closeReportSheet:
                state.isReportSheetVisible = false
                state.modalOffset = Constant.screenHeight
                return .none

            case .reportButtonTapped:
                return .merge(
                    .send(.setShowingElseMenu(false)),
                    .send(.openReportSheet)
                )

            case .report(.closeModal):
                return .send(.closeReportSheet)

            default:
                return .none
            }
        }
    }
}
