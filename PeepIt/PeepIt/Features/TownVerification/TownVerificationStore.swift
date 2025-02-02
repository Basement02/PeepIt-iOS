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
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case registerButtonTapped
        case backButtonTapped
        case dismissButtonTapped
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

            default:
                return .none
            }
        }
    }
}
