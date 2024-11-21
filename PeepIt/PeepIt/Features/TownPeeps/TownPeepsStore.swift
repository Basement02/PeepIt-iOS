//
//  TownPeepsStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TownPeepsStore {

    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case backButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .backButtonTapped:
                return .run { _ in
                     await self.dismiss()
                }
            }
        }
    }
}
