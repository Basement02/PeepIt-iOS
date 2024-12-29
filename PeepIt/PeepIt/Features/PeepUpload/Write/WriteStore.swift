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
        /// 본문
        var bodyText = ""
        /// 본문 입력 모드
        var isBodyInputMode = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dismissButtonTapped
        case uploadButtonTapped
        case bodyTextEditorTapped
        case doneButtonTapped
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

            default:
                return .none
            }
        }
    }
}
