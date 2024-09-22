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
        var sheetHeight = SheetType.scrollDown.height
        var isSheetScrolledDown = false
        var offset = CGFloat(0)
        var lastOffset = CGFloat(0)
        var isPeepDetailShowed = false
        var isSideMenuShowed = false
        var sideMenuOffset = -UIScreen.main.bounds.width

        var peepDetail = PeepDetailStore.State()
        var sideMenu = SideMenuStore.State()
    }

    enum Action {
        case setSheetHeight(height: CGFloat)
        case modalDragged(dragHeight: CGFloat)
        case modalDragEnded
        case previewPeepTapped
        case peepDetail(PeepDetailStore.Action)
        case sideMenu(SideMenuStore.Action)
        case sideMenuButtonTapped
        case dragSideMenu(dragWidth: CGFloat)
        case dragSideMenuEnded
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.peepDetail, action: \.peepDetail) {
            PeepDetailStore()
        }
        
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

                return .send(.setSheetHeight(height: -state.offset + SheetType.scrollDown.height))

            case .modalDragEnded:
                if -state.offset > SheetType.scrollUp.height / 2 {
                    state.offset = -(SheetType.scrollUp.height - SheetType.scrollDown.height)
                } else {
                    state.offset = 0
                }
                
                state.lastOffset = state.offset
                return .send(.setSheetHeight(height: -state.offset + SheetType.scrollDown.height))

            case .previewPeepTapped:
                state.isPeepDetailShowed = true
                return .none

            case .peepDetail(.closeView):
                state.isPeepDetailShowed = false
                return .none

            case .sideMenuButtonTapped:
                state.sideMenuOffset = 0
                return .none

            case .sideMenu:
                return .none

            case let .dragSideMenu(dragWidth):
                state.sideMenuOffset = dragWidth
                return .none

            case .dragSideMenuEnded:
                state.sideMenuOffset = -UIScreen.main.bounds.width
                return .none

            default:
                return .none
            }
        }
    }
}
