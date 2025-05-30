//
//  MyProfileStore.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyProfileStore {

    @ObservableState
    struct State: Equatable {
        /// 사용자 프로필
        var myProfile: UserProfile?

        /// 나의 핍, 나의 활동 탭 선택
        var peepTabSelection = PeepTabType.uploaded

        /// 나의 활동 필터 탭
        var myTabFilter = MyActivityType.all

        enum MyActivityType: String, CaseIterable {
            case all = "전체"
            case chat = "참여한 핍"
            case react = "반응한 핍"
        }

        /// 업로드한 핍 관리 (나의 핍 탭)*
        var uploadedPeeps: [Peep] = []
        var uploadedPeepPage = 0
        var uploadedPeepHasNext = true

        /// 활동 핍 관리 (나의 활동 탭)
        var activityPeeps: [Peep] = []
        var activityPeepPage = 0
        var activityPeepHasNext = true

        /// 활동 핍 개수
        var allCnt = 0
        var chattedCnt = 0
        var reactedCnt = 0

        /// 핍 페이지네이션 사이즈
        var size = 15
    }

    enum Action {
        case onAppear
        case backButtonTapped
        case modifyButtonTapped
        case peepTabTapped(selection: PeepTabType)
        case myTabTapped(selection: MyProfileStore.State.MyActivityType)
        case uploadButtonTapped
        case watchButtonTapped
        case peepCellTapped(peep: Peep)

        /// 프로필 정보 불러오기
        case updateMyProfile(profile: UserProfile)

        /// 사용자가 업로드한 핍 조회 API
        case fetchUploadedPeeps
        case fetchUploadedPeepsResponse(Result<PagedPeeps, Error>)

        /// 사용자가 참여한  핍 조회 API
        case fetchChattedPeeps
        case fetchChattedPeepsResponse(Result<PagedPeeps, Error>)

        /// 사용자가 반응한 핍 조회 API
        case fetchReactedPeeps
        case fetchReactedPeepsResponse(Result<PagedPeeps, Error>)

        /// 나의 활동 핍 페이지네이션
        case fetchMoreActivityPeeps
    }

    @Dependency(\.userProfileStorage) var userProfileStorage
    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {

            case .onAppear:
                state.peepTabSelection = .uploaded
                state.uploadedPeepPage = 0
                state.uploadedPeepHasNext = true

                return .merge(
                    .run { send in
                        if let savedProfile = try? await userProfileStorage.load() {
                            await send(.updateMyProfile(profile: savedProfile))
                        }
                    },
                    .run { send in
                        await send(.fetchUploadedPeeps)
                    }
                )

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case let .updateMyProfile(profile):
                state.myProfile = profile

                return .none

            case let .peepTabTapped(selection):
                state.peepTabSelection = selection

                switch selection {
                case .uploaded:
                    state.uploadedPeepPage = 0
                    state.uploadedPeepHasNext = true
                    state.uploadedPeeps = .init()
                    return .send(.fetchUploadedPeeps)

                case .myActivity:
                    state.myTabFilter = .all
                    state.activityPeepPage = 0
                    state.activityPeepHasNext = true
                    return .send(.fetchChattedPeeps)
                }

            case let .myTabTapped(selection):
                state.activityPeeps = []
                state.activityPeepPage = 0
                state.activityPeepHasNext = true
                
                state.myTabFilter = selection

                switch selection {
                case .all:
                    return .none
                case .chat:
                    return .send(.fetchChattedPeeps)
                case .react:
                    return .send(.fetchReactedPeeps)
                }

            case .uploadButtonTapped, .watchButtonTapped, .peepCellTapped, .modifyButtonTapped:
                return .none

            case .fetchUploadedPeeps:
                let page = state.uploadedPeepPage
                let size = state.size

                return .run { send in
                    await send(
                        .fetchUploadedPeepsResponse(
                            Result { try await peepAPIClient.fetchUploadedPeeps(page, size) }
                        )
                    )
                }

            case let .fetchUploadedPeepsResponse(result):
                switch result {

                case let .success(pagedPeeps):

                    if pagedPeeps.page == 0 {
                        state.uploadedPeeps = pagedPeeps.content
                    } else {
                        state.uploadedPeeps.append(contentsOf: pagedPeeps.content)
                    }

                    state.uploadedPeepHasNext = pagedPeeps.hasNext
                    state.uploadedPeepPage += 1
                    
                    return .none

                case let .failure(error):
                    // TODO: 에러 처리
                    print(error)
                    return .none
                }

            case .fetchChattedPeeps:
                let page = state.activityPeepPage
                let size = state.size

                return .run { send in
                    await send(
                        .fetchChattedPeepsResponse(
                            Result { try await peepAPIClient.fetchChattedPeeps(page, size) }
                        )
                    )
                }

            case let .fetchChattedPeepsResponse(result):
                switch result {

                case let .success(pagedPeeps):

                    state.chattedCnt = pagedPeeps.totalElements
                    state.activityPeeps.append(contentsOf: pagedPeeps.content)
                    state.activityPeepHasNext = pagedPeeps.hasNext
                    state.activityPeepPage += 1
                    
                    return .none

                case let .failure(error):
                    // TODO: 에러 처리
                    return .none
                }

            case .fetchReactedPeeps:
                let page = state.activityPeepPage
                let size = state.size

                return .run { send in
                    await send(
                        .fetchReactedPeepsResponse(
                            Result { try await peepAPIClient.fetchReactedPeeps(page, size) }
                        )
                    )
                }

            case let .fetchReactedPeepsResponse(result):
                switch result {

                case let .success(pagedPeeps):
                    state.reactedCnt = pagedPeeps.totalElements
                    state.activityPeeps.append(contentsOf: pagedPeeps.content)
                    state.activityPeepHasNext = pagedPeeps.hasNext
                    state.activityPeepPage += 1
                    return .none

                case .failure:
                    // TODO: 에러 처리
                    return .none
                }

            case .fetchMoreActivityPeeps:
                switch state.myTabFilter {
                case .all: return .none // TODO: 수정
                case .chat: return .send(.fetchChattedPeeps)
                case .react: return .send(.fetchReactedPeeps)
                }
            }
        }
    }
}
