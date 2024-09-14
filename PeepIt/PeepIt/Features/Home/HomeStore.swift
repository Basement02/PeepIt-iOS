//
//  HomeStore.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct HomeStore {
    
    @ObservableState
    struct State {
        var sheetType: SheetType = .fold
    }

    enum Action {
        case setSheet(isExpanded: Bool)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setSheet(isExpanded):
                state.sheetType = isExpanded ? .unfold : .fold
                return .none
            }
        }
    }
}
