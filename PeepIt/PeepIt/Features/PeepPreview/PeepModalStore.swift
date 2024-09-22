//
//  CustomModalStore.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PeepModalStore {

    @ObservableState
    struct State: Equatable {
        var sheetHeight = SheetType.scrollDown.height
        var isSheetScrolledDown = false
        var offset = CGFloat(0)
        var lastOffset = CGFloat(0)
    }

    enum Action {
        case setSheetHeight(height: CGFloat)
        case modalDragged(dragHeight: CGFloat)
        case modalDragEnded
        case peepCellTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setSheetHeight(height):
                state.sheetHeight = height
                state.isSheetScrolledDown = (height == SheetType.scrollDown.height)

                return .none

            case let .modalDragged(dragHeight):
                state.offset = max(
                    dragHeight,
                    -(SheetType.scrollUp.height - SheetType.scrollDown.height)
                ) + state.lastOffset

                return .send(
                    .setSheetHeight(height: -state.offset + SheetType.scrollDown.height)
                )

            case .modalDragEnded:
                if -state.offset > SheetType.scrollUp.height / 2 {
                    state.offset = -(SheetType.scrollUp.height - SheetType.scrollDown.height)
                } else {
                    state.offset = 0
                }

                state.lastOffset = state.offset
                
                return .send(
                    .setSheetHeight(height: -state.offset + SheetType.scrollDown.height)
                )

            case .peepCellTapped:
                return .none
            }
        }
    }
}
