//
//  ReportStore.swift
//  PeepIt
//
//  Created by 김민 on 11/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ReportStore {

    @ObservableState
    struct State: Equatable {

        /// 선택된 신고 사유
        var selectedReportReason: ReportReasonType?
        /// 신고 사유 선택 목록 오픈 여부
        var isReasonListShowed = false
        /// '다른 문제가 있어요' 선택 시 작성되는 신고 사유
        var reportReason = ""
        /// 신고 사유 enum
        enum ReportReasonType: String, CaseIterable {
            case inappropriate = "부적절한 내용을 업로드해요"
            case irrelevant = "동네와 상관없는 내용을 업로드해요"
            case offensive = "불쾌한 표현이 포함되어 있어요"
            case spam = "홍보 목적의 글을 도배해요"
            case other = "다른 문제가 있어요"
        }

        var modalOffset = Constant.screenHeight
        var showModalBg = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 모달 띄우기
        case openModal
        /// 신고 사유 선택 초기 버튼 탭
        case reasonSelectButtonTapped
        /// 신고 사유 선택
        case reasonSelected(type: State.ReportReasonType)
        /// 모달 내리기
        case closeSheet
        /// 드래그
        case dragOnChanged(height: CGFloat)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.reportReason):
                return .none

            case .openModal:
                state.showModalBg = true
                state.modalOffset = 0
                return .none

            case .reasonSelectButtonTapped:
                state.isReasonListShowed.toggle()
                return .none

            case let .reasonSelected(type):
                state.isReasonListShowed = false
                state.selectedReportReason = type
                return .none

            case .closeSheet:
                state.showModalBg = false
                state.isReasonListShowed = false
                state.selectedReportReason = nil
                state.modalOffset = Constant.screenHeight
                return .none

            case let .dragOnChanged(height):
                state.modalOffset = height
                return .none

            default:
                return .none
            }
        }
    }
}
