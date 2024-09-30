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
    }

    enum Action {
        case loginButtonTapped(type: LoginType)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .loginButtonTapped(type):
                return .none
            }
        }
    }
}
