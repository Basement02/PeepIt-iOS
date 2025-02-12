//
//  WriteStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct WriteStore {

    @ObservableState
    struct State: Equatable {
        /// 전달된 편집 이미지
        var image: UIImage? = nil
        /// 전달된 편집 영상
        var videoURL: URL? = nil
        /// 본문
        var bodyText = ""
        /// 본문 입력 모드
        var isBodyInputMode = false
        /// 지도 모달 offset
        var modalOffset = Constant.screenHeight
        /// 키보드 관리
        var keyboardHeight = CGFloat(0)
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dismissButtonTapped
        case uploadButtonTapped
        case bodyTextEditorTapped
        case doneButtonTapped
        case addressTapped
        case viewTapped
        case modalDragOnChanged(height: CGFloat)
        case closeModal
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.bodyText):
                return .none

            case .dismissButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .uploadButtonTapped:
                return .none

            case .bodyTextEditorTapped:
                state.isBodyInputMode = true
                return .none

            case .doneButtonTapped:
                state.isBodyInputMode = false
                return .none

            case .addressTapped:
                state.modalOffset = 0
                return .none

            case .viewTapped:
                return .send(.closeModal)

            case let .modalDragOnChanged(value):
                state.modalOffset = value
                return .none

            case .closeModal:
                state.modalOffset = Constant.screenHeight
                return .none

            default:
                return .none
            }
        }
    }
}
