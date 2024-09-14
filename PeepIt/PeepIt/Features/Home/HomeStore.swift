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
        var sheetHeight: CGFloat = SheetType.scrollDown.height
        var isExpanded: Bool = false
    }

    enum Action {
        case setSheetHeight(height: CGFloat)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setSheetHeight(height):
                state.sheetHeight = height
                state.isExpanded = (height == SheetType.scrollUp.height)
                return .none
            }
        }
    }
}
