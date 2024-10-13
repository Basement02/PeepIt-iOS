//
//  WelcomeStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WelcomeStore {

    @ObservableState
    struct State: Equatable {
        var isAuthorized = true
    }

    enum Action {
        case goToHomeButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .goToHomeButtonTapped:
                return .none
            }
        }
    }
}
