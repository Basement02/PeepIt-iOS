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
        /// 핍 상세 진입 경로
        var entryType = EntryType.peepPreview
        /// 스크롤된 핍 리스트
        var peepList: [Peep] = []
        /// 현재 핍 인덱스
        var currentIdx = 0
        /// 반응 리스트
        var reactionList = ReactionType.allCases
        /// 선택된 반응
        var selectedReaction: ReactionType?
        /// 반응 리스트 뷰에 보여주기 여부
        var showReactionList = false
        /// 더보기 메뉴 보여주기 여부
        var showElseMenu = false
        /// 차단 모달 보여주기 여부
        var isReportSheetVisible = false
        /// 신고 모달 offset 관련
        var modalOffset = Constant.screenHeight
        /// 신고 모달 관련
        var report = ReportStore.State()
        /// 채팅 보여주기
        var showChat = false
        /// 채팅 관련
        var chatState = ChatStore.State()
        /// 반응 선택 x일 때 보여줄 리액션들
        var showingReactionIdx = 0
        /// 핍 상세 나타날 때 위의 오브젝트들 보여주기 여부
        var showPeepDetailObject = false
        /// 핍 상세 나타날 때 백그라운드 보여줄 타이밍 
        var showPeepDetailBg = false
        /// 공유시트
        var showShareSheet = false

        // TODO: 이모티콘 추후 수정
        enum ReactionType: String, CaseIterable {
            case a = "😀"
            case b = "😥"
            case c = "🤔"
            case d = "😙"
            case e = "😍"
        }

        enum EntryType {
            case peepPreview
            case townPeep
            case notification
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 뷰 나타날 때
        case onAppear
        /// 반응 리스트 보여주기
        case initialReactionButtonTapped
        /// 채팅 뷰 보여주기
        case showChat
        /// 뒤로 가기
        case backButtonTapped
        /// 반응 선택
        case selectReaction(reaction: PeepDetailStore.State.ReactionType)
        /// 선택 해제
        case unselectReaction
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
        /// 채팅 관련
        case chatAction(ChatStore.Action)
        /// 뷰 탭
        case viewTapped
        /// 공유하기
        case shareButtonTapped

        /// 타이머
        case setTimer
        case timerTicked
        case stopTimer
    }

    enum CancelId {
        case timer
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.report, action: \.report) {
            ReportStore()
        }

        Scope(state: \.chatState, action: \.chatAction) {
            ChatStore()
        }

        Reduce { state, action in
            switch action {

            case .binding(\.currentIdx):
                return .none
                
            case .binding(\.showShareSheet):
                return .none

            case .onAppear:
                return .send(.setTimer)

            case .initialReactionButtonTapped:
                state.showReactionList = true
                return .none

            case .showChat:
                state.showChat = true
                return .none

            case .backButtonTapped:
                state.showPeepDetailBg = false
                state.showPeepDetailObject = false

                let entry = state.entryType
                return .run { _ in
                    guard entry != .peepPreview else { return }
                    await dismiss()
                }

            case let .selectReaction(selectedReaction):
                if state.selectedReaction == selectedReaction { return .send(.unselectReaction) }

                state.selectedReaction = selectedReaction
                state.showReactionList = false

                return .send(.stopTimer)

            case .unselectReaction:
                state.reactionList = PeepDetailStore.State.ReactionType.allCases
                state.selectedReaction = nil
                state.showReactionList = false
                return .send(.setTimer)

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

            case .report(.closeButtonTapped):
                return .send(.closeReportSheet)

            case .chatAction(.closeChatButtonTapped):
                state.showChat = false
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

            case let .report(.dragOnChanged(height)):
                state.modalOffset = height
                return .none

            case .viewTapped:
                state.showElseMenu = false
                return .none

            case .shareButtonTapped:
                state.showShareSheet.toggle()
                return .none

            default:
                return .none
            }
        }
    }
}
