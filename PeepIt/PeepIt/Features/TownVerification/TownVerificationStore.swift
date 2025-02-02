//
//  TownVerificationStore.swift
//  PeepIt
//
//  Created by 김민 on 2/3/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TownVerificationStore {

    @ObservableState
    struct State: Equatable {
        var isSheetVisible = false
        var modalOffset = Constant.screenHeight
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case modalDragOnChanged(height: CGFloat)
        case registerButtonTapped
        case backButtonTapped
        case dismissButtonTapped
        case closeModal
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .registerButtonTapped:
                state.isSheetVisible = true
                return .none

            case .backButtonTapped:
                state.isSheetVisible = false
                return .none

            case .dismissButtonTapped:
                state.isSheetVisible = false
                return .none

            case let .modalDragOnChanged(height):
                state.modalOffset = height
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
