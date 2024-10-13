//
//  ProfileInfoStore.swift
//  PeepIt
//
//  Created by 김민 on 10/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileInfoStore {

    @ObservableState
    struct State: Equatable {
        var date = ""
        var selectedGender: GenderType?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectedGender(GenderType)
        case nextButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.date):
                return .none

            case let .selectedGender(gender):
                state.selectedGender = state.selectedGender == gender ? nil : gender
                return .none

            case .nextButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}
