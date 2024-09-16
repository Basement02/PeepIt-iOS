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
    struct State: Equatable {
        var sheetHeight: CGFloat = SheetType.scrollDown.height
        var isScrolledDown: Bool = false
        var offset: CGFloat = 0
        var lastOffset: CGFloat = 0
    }

    enum Action {
        case setSheetHeight(height: CGFloat)
        case dragChanged(translationHeight: CGFloat)
        case drageEnded
        case previewPeepTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setSheetHeight(height):
                state.sheetHeight = height
                state.isScrolledDown = (height == SheetType.scrollDown.height)
                return .none

            case let .dragChanged(translationHeight):
                state.offset = max(
                    translationHeight,
                    -(SheetType.scrollUp.height - SheetType.scrollDown.height)
                ) + state.lastOffset

                return .send(.setSheetHeight(height: -state.offset + SheetType.scrollDown.height))

            case .drageEnded:
                if -state.offset > SheetType.scrollUp.height / 2 {
                    state.offset = -(SheetType.scrollUp.height - SheetType.scrollDown.height)
                } else {
                    state.offset = 0
                }
                
                state.lastOffset = state.offset
                return .send(.setSheetHeight(height: -state.offset + SheetType.scrollDown.height))

            case .previewPeepTapped:
                print("tap: preview peep")
                return .none
            }
        }
    }
}
