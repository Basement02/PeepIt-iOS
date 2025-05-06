//
//  PeepDetailListStore.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import ComposableArchitecture

@Reducer
struct PeepDetailListStore {

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
        /// 반응 리스트 뷰에 보여주기 여부
        var showReactionList = false
        /// 더보기 메뉴 보여주기 여부
        var showElseMenu = false
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
            case others
        }

        var size = 5
        var page = 0
        var hasNext = true

        var peepIdList: [Int] = []
        var peepCache: [Int: Peep] = [:] // idx: peep
        var peepLocation: [Int: String] = [:] // idx: building name
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
        case selectReaction(reaction: PeepDetailListStore.State.ReactionType)
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
        /// 리액션 설정
        case setReaction

        /// 타이머
        case setTimer
        case timerTicked
        case stopTimer

        /// 개별 핍 api
        case getPeepDetail(id: Int)
        case fetchPeepDetailResponse(Result<Peep, Error>)

        /// 다음 핍 페이지네이션 api
        case getNextPeepIds(page: Int, size: Int)
        case fetchNextPeepIdsResponse(Result<PagedPeeps, Error>)

        /// 이전 핍 페이지네이션 api
        case getPrevPeepIds(page: Int, size: Int)
        case fetchPrevPeepIdsResponse(Result<PagedPeeps, Error>)

        /// 현재 보고 있는 핍 앞뒤 2개를 미리 fetch
        case prefetch
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

        Scope(state: \.chatState, action: \.chatAction) {
            ChatStore()
        }

        Reduce { state, action in
            switch action {

            case .binding(\.currentIdx):

                var effects: [Effect<Action>] = []

                if state.currentIdx >= state.peepIdList.count - 2 && state.hasNext {
                    effects.append(.send(.getNextPeepIds(page: state.page + 1, size: state.size)))
                }

                if state.currentIdx == 0 && state.page > 0 {
                    effects.append(.send(.getPrevPeepIds(page: state.page - 1, size: state.size)))
                }

                effects.append(.send(.prefetch))

                return .merge(effects)


            case .binding(\.showShareSheet):
                return .none

            case .onAppear:
                return .merge(
                    .send(.getPeepDetail(id: state.peepIdList[state.currentIdx])),
                    .send(.prefetch)
                )

            // TODO: 리액션 로직 수정
            case .setReaction:
//                guard let peep = state.peeps[safe: state.currentIdx],
//                      let reactionStr = peep?.reaction else {
//                    return .send(.setTimer)
//                }
//
//                state.peeps[state.currentIdx]?.reaction = reactionStr

                return .none

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
                state.showReactionList = false

                guard let reactionStr = state.peepList[state.currentIdx].reaction,
                      reactionStr == selectedReaction.rawValue else {
                    state.peepList[state.currentIdx].reaction = selectedReaction.rawValue
                    return .send(.stopTimer)
                }

                return .send(.unselectReaction)

            case .unselectReaction:
                state.reactionList = PeepDetailListStore.State.ReactionType.allCases
                state.peepList[state.currentIdx].reaction = nil
                return .send(.setTimer)

            case let .setShowingElseMenu(newState):
                state.showElseMenu = newState
                return .none

            case .reportButtonTapped:
                state.showElseMenu = false
                return .send(.report(.openModal))

            case .chatAction(.closeChatDetail):
                state.showChat = false
                return .none

            // TODO: 타이머 로직 수정
            case .setTimer:
//                guard state.peeps[state.currentIdx].reaction == nil else { return .none }
//
//                return .run { send in
//                    while true {
//                        try await Task.sleep(for: .seconds(0.75))
//                        await send(.timerTicked)
//                    }
//                }
//                .cancellable(id: CancelId.timer)
                return .none

            case .timerTicked:
                state.showingReactionIdx = (state.showingReactionIdx + 1) % state.reactionList.count
                return .none

            case .stopTimer:
                return .cancel(id: CancelId.timer)

            case .viewTapped:
                state.showElseMenu = false
                state.showReactionList = false
                return .none

            case .shareButtonTapped:
                state.showShareSheet.toggle()
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
                    if let idx = state.peepIdList.firstIndex(of: peep.id) {
                        state.peepCache[idx] = peep
                        state.peepLocation[idx] = peep.buildingName
                    }

                case let .failure(error):
                    print(error)
                }

                return .none

            case let .getNextPeepIds(page, size):
                return .run { send in
                    await send(
                        .fetchNextPeepIdsResponse(
                            Result { try await peepAPIClient.fetchTownPeeps(page, size) }
                        )
                    )
                }

            case let .fetchNextPeepIdsResponse(result):
                switch result {

                case let .success(res):
                    state.peepIdList.append(contentsOf: res.content.map { $0.peepId })
                    state.hasNext = res.hasNext
                    state.page = res.page

                    return .send(.prefetch)

                case let .failure(error):
                    print("다음 핍 페이지네이션", error)
                }

                return .none

            case let .getPrevPeepIds(page, size):
                return .run { send in
                    await send(
                        .fetchNextPeepIdsResponse(
                            Result { try await peepAPIClient.fetchTownPeeps(page, size) }
                        )
                    )
                }

            case let .fetchPrevPeepIdsResponse(result):
                switch result {

                case let .success(res):
                    state.peepIdList.insert(contentsOf: res.content.map { $0.peepId }, at: 0)
                    state.hasNext = res.hasNext
                    state.page = max(0, state.page-1)

                case let .failure(error):
                    print("이전 핍 페이지네이션", error)
                }

                return .none

            case .prefetch:
                let current = state.currentIdx
                let prefetchRange = (current - 2)...(current + 2)

                // 가져와야 할 핍 ID들 선정
                let prefetchIds = prefetchRange
                    .compactMap { idx in state.peepIdList[safe: idx] }
                    .filter { id in
                        let idx = state.peepIdList.firstIndex(of: id)!
                        return state.peepCache[idx] == nil
                    }

                // 슬라이딩 범위 밖 캐시 제거
                let validIndices = Set(prefetchRange)
                state.peepCache = state.peepCache.filter { (idx, _) in
                    validIndices.contains(idx)
                }

                // 필요한 ID만 개별 핍 api 요청
                return .run { send in
                    for id in prefetchIds {
                        await send(.getPeepDetail(id: id))
                    }
                }

            default:
                return .none
            }
        }
    }
}

extension Array {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
