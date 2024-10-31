//
//  CheckEnterFieldStore.swift
//  PeepIt
//
//  Created by 김민 on 10/31/24.
//

import Foundation
import ComposableArchitecture

enum EnterState: Equatable {
    case base
    case completed
    case error
}

@Reducer
struct CheckEnterFieldStore {

    @ObservableState
    struct State: Equatable {
        var content = "항목"
        var text = ""
        var message = "가이드 문구"
        var enterState = EnterState.base
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.text):
                return .none

            default:
                return .none
            }
        }
    }
}

