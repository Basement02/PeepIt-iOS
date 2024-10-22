//
//  CameraStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CameraStore {

    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case shootButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .shootButtonTapped:
                return .none
            }
        }
    }
}
