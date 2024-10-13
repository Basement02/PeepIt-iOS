//
//  EditStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EditStore {

    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case soundOnOffButtonTapped
        case stickerButtonTapped
        case textButtonTapped
        case uploadButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .soundOnOffButtonTapped:
                return .none

            case .stickerButtonTapped:
                return .none

            case .textButtonTapped:
                return .none

            case .uploadButtonTapped:
                return .none
            }
        }
    }
}
