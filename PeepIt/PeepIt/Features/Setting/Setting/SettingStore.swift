//
//  SettingStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingStore {

    @ObservableState
    struct State: Equatable {

        /// 탈퇴 모달 보여주기 여부
        var isWithdrawSheetVisible = false

        /// 모달 offset 관련
        var modalOffset = Constant.screenHeight

        /// 탈퇴 사유
        var selectedWithdrawType: WithdrawType? = nil

        /// 탈퇴 사유 메세지
        var withdrawReason = ""

        /// 탈퇴 사유 입력 focus
        var isTextEditorFocused = false

        /// 탈퇴 메세지
        var withdrawMessage = ""

        /// 탈퇴 버튼 보여주기 여부
        var isWithdrawActivated = false

        /// 설정 종류
        enum ServiceTermType: String, CaseIterable {
            case alarm = "알림 설정"
            case guide = "이용 안내"
            case mail = "문의하기"

            func destinationState() -> RootStore.Path.State? {
                switch self {
                case .alarm:
                    return .notificationSetting(NotificationSettingStore.State())
                case .guide:
                    return .guide(GuideStore.State())
                case .mail:
                    return nil
                }
            }
        }

        /// 탈퇴 사유 종류
        enum WithdrawType: String, CaseIterable {
            case notUser = "자주 사용하지 않아요"
            case privacy = "개인 정보가 걱정돼요"
            case bug = "앱 오류가 있어요"
            case duplicated = "중복 계정이 있어요"
            case wantToDelete = "삭제하고 싶은 내용이 있어요"
            case write = "직접 입력할게요"
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case openSheet
        case closeSheet
        case withdraw
        case selectWithdrawType(type: State.WithdrawType)
        case textEditorTapped
        case modalDragChanged(offset: CGFloat)
        case modalDragEnded
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {

            case .binding(\.withdrawMessage):
                state.isWithdrawActivated = state.withdrawMessage == "서비스 탈퇴에 동의합니다."
                return .none

            case .backButtonTapped:
                return .run { _ in
                     await self.dismiss()
                }

            case .openSheet:
                state.isWithdrawSheetVisible = true
                state.modalOffset = 0
                return .none

            case .closeSheet:
                state.isWithdrawSheetVisible = false
                state.modalOffset = Constant.screenHeight
                return .none

            case .withdraw:
                // TODO: 탈퇴 API 
                return .none

            case let .selectWithdrawType(type):
                state.selectedWithdrawType = type
                return .none

            case .textEditorTapped:
                state.isTextEditorFocused = true
                return .none

            case let .modalDragChanged(offset):
                state.modalOffset = max(offset, 0)
                return .none

            case .modalDragEnded:
                if state.modalOffset > 100 {
                    return .send(.closeSheet)
                } else {
                    state.modalOffset = 0
                    return .none
                }

            default:
                return .none
            }
        }
    }
}
