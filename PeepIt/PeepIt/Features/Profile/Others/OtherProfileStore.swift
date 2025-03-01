//
//  OtherProfileStore.swift
//  PeepIt
//
//  Created by 김민 on 9/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OtherProfileStore {

    @ObservableState
    struct State: Equatable {
        /// 핍 리스트
        var uploadedPeeps: [Peep] = [.stubPeep0, .stubPeep1, .stubPeep2, .stubPeep3, .stubPeep4, .stubPeep5, .stubPeep6, .stubPeep7, .stubPeep8, .stubPeep9]
        /// 상단 우측 더보기 버튼 탭 여부
        var isElseButtonTapped = false
        /// 유저 차단 여부
        var isUserBlocked = false
        /// 모달 offset 관련
        var modalOffset = Constant.screenHeight
        /// 모달 보여주기 여부
        var isModalVisible = false
        /// 공유하기 보여주기
        var showShareSheet = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 뷰 나타날 때
        case onAppear
        /// 더보기 버튼 탭했을 때
        case elseButtonTapped(_ newState: Bool)
        /// 뒤로가기 버튼 탭했을 때
        case backButtonTapped
        /// 더보기 - 차단 관련(차단하기/차단해제) 버튼 탭했을 때
        case elseBlockButtonTapped
        /// 현재 유저 차단하기
        case blockUser
        /// 현재 유저 차단 해제하기
        case unblockUser
        /// 취소하기
        case closeModal
        /// 모달 열기
        case openModal
        /// 모달 드래그 변화
        case modalDragChanged(offset: CGFloat)
        /// 모달 드래그 끝남
        case modalDragEnded
        /// 뷰 탭
        case viewTapped
        /// 공유하기 버튼 탭
        case shareButtonTapped
        /// 핍 셀 선택
        case peepCellTapped(peep: Peep)
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.showShareSheet):
                return .none

            case .onAppear:
                // TODO: 차단 여부 로드
                return .none

            case let .elseButtonTapped(newState):
                state.isElseButtonTapped = newState
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }

            case .elseBlockButtonTapped:
                if state.isUserBlocked {
                    return .send(.unblockUser)
                } else {
                    return .send(.openModal)
                }

            case .blockUser:
                // TODO: 차단 api 호출
                state.isUserBlocked = true
                return .send(.closeModal)

            case .unblockUser:
                // TODO: 차단 해제 api 호출
                state.isUserBlocked = false
                state.isElseButtonTapped = false
                return .none

            case .openModal:
                state.modalOffset = 0
                state.isModalVisible = true
                state.isElseButtonTapped = false
                return .none

            case .closeModal:
                state.modalOffset = Constant.screenHeight
                state.isModalVisible = false
                return .none

            case let .modalDragChanged(offset):
                state.modalOffset = max(offset, 0)
                return .none

            case .modalDragEnded:
                if state.modalOffset > 100 {
                    return .send(.closeModal)
                } else {
                    state.modalOffset = 0
                    return .none
                }

            case .viewTapped:
                state.isElseButtonTapped = false

                return .none

            case .shareButtonTapped:
                state.showShareSheet.toggle()
                return .none

            case .peepCellTapped:
                return .none
                
            default:
                return .none
            }
        }
    }
}
