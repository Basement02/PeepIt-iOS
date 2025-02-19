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
        var baseOffset = SheetType.scrollDown.offset

        var isSheetScrolledDown: Bool {
            return modalOffset == SheetType.scrollDown.offset
        }

        var modalOffset = CGFloat(SheetType.scrollDown.offset)

        var scrollOffsetX: CGFloat = .zero
        var dragEndedOffset: CGFloat = .zero
        var isScrolling = true
        var isAutoScroll = false

        var showPeepDetail = false

        enum SheetType: CaseIterable {
            case scrollDown, scrollUp

            var height: CGFloat {
                switch self {
                case .scrollDown:
                    return CGFloat(100)
                case .scrollUp:
                    return CGFloat(457)
                }
            }

            var offset: CGFloat {
                switch self {
                case .scrollDown:
                    return CGFloat(457-100)
                case .scrollUp:
                    return CGFloat(0)
                }
            }
        }
    }

    enum Action {
        case modalDragged(dragHeight: CGFloat)
        case modalDragEnded(dragHeight: CGFloat)
        case peepCellTapped(idx: Int)
        case scrollUpButtonTapped
        case peepScrollUpdated(CGFloat)
        case peepScrollEnded
        case autoScrollStarted
        case autoScrollEnded
        case setPeepScrollOffset(CGFloat)
        case showPeepDetail
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case let .modalDragged(dragHeight):
                state.modalOffset = max(
                    min(state.baseOffset + dragHeight, State.SheetType.scrollDown.offset),
                    State.SheetType.scrollUp.offset
                )
                return .none

            case let .modalDragEnded(dragHeight):
                let isScrollingUp = dragHeight < 0
                let shouldSnapUp = abs(dragHeight) > 60

                state.baseOffset = shouldSnapUp
                    ? (isScrollingUp ? State.SheetType.scrollUp.offset : State.SheetType.scrollDown.offset)
                    : (isScrollingUp ? State.SheetType.scrollDown.offset : State.SheetType.scrollUp.offset)

                state.modalOffset = state.baseOffset

                return .none

            case .peepCellTapped:
                state.showPeepDetail = true

                return .run { send in
                    try await Task.sleep(for: .seconds(0.1))
                    await send(.showPeepDetail)
                }

            case .scrollUpButtonTapped:
                state.modalOffset = State.SheetType.scrollUp.offset
                state.baseOffset = State.SheetType.scrollUp.offset
                return .none

            case let .peepScrollUpdated(offset):
                state.dragEndedOffset = offset
                state.isScrolling = true
                return .none

            case .peepScrollEnded:
                state.isScrolling = false
                return .none

            case .autoScrollStarted:
                state.isAutoScroll = true
                return .none

            case .autoScrollEnded:
                state.isAutoScroll = false
                return .none

            case let .setPeepScrollOffset(offset):
                state.scrollOffsetX = offset
                return .none

            case .showPeepDetail:
                return .none
            }
        }
    }
}

