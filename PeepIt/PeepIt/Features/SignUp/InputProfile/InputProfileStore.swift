//
//  InputProfileStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct InputProfileStore {

    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case nextButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .none
            }
        }
    }
}
