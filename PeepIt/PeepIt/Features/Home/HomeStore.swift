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
        var isPeepDetailShowed: Bool = false
        var isSideMenuShowed: Bool = false

        var peepDetail = PeepDetailStore.State()
        var sideMenu = SideMenuStore.State()
    }

    enum Action {
        case setSheetHeight(height: CGFloat)
        case dragChanged(translationHeight: CGFloat)
        case drageEnded
        case previewPeepTapped
        case peepDetail(PeepDetailStore.Action)
        case sideMenu(SideMenuStore.Action)
        case sideMenuButtonTapped
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.peepDetail, action: \.peepDetail) {
            PeepDetailStore()
        }
        
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
                state.isPeepDetailShowed = true
                return .none

            case .peepDetail(.closeView):
                state.isPeepDetailShowed = false
                return .none

            case .sideMenuButtonTapped:
                state.isSideMenuShowed = true
                return .none

            case .sideMenu:
                return .none

            default:
                return .none
            }
        }
    }
}
