//
//  LoginStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LoginStore {

    @ObservableState
    struct State: Equatable {
        var currentTab = 0
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonTapped(type: LoginType)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.currentTab):
                return .none

            case .loginButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}
