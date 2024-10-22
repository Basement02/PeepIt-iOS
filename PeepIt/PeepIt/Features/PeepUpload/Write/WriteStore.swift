//
//  WriteStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WriteStore {

    @ObservableState
    struct State: Equatable {
        var textView = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case uploadButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.textView):
                return .none

            case .uploadButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}
