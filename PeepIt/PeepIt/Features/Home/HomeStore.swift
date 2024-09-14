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
    
    struct State: Equatable {
        var sheetHeight: CGFloat = SheetType.scrollDown.height
        var isScrolledDown: Bool = false
    }

    enum Action {
        case setSheetHeight(height: CGFloat)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setSheetHeight(height):
                state.sheetHeight = height
                state.isScrolledDown = (height == SheetType.scrollDown.height)
                return .none
            }
        }
    }
}
