//
//  GuideStore.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GuideStore {

    @ObservableState
    struct State: Equatable {
        /// 약관 안내 sheet
        var isSheetVisible = false
        /// 선택된 약관
        var selectedGuideType: GuideType? = nil

        /// 이용약관 타입
        enum GuideType: String, CaseIterable {
            case service = "서비스 이용 약관"
            case privacy = "개인 정보 처리 방침"
            case openSource = "오픈 소스 라이선스"
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 이용약관 뒤로가기 탭
        case backButtonTapped
        /// 이용약관 모달 끄기 버튼 탭
        case sheetDismissButtonTapped
        /// 셀 탭
        case guideCellTapped(type: State.GuideType)
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case .sheetDismissButtonTapped:
                state.isSheetVisible = false
                state.selectedGuideType = nil
                return .none

            case let .guideCellTapped(type):
                state.selectedGuideType = type
                state.isSheetVisible = true
                return .none

            default:
                return .none
            }
        }
    }
}
