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
        var isSheetScrolledDown: Bool {
            return modalOffset > 0
        }
        var modalOffset = CGFloat(SheetType.scrollDown.offset)
        var showPeepDetail = false
        var peeps: [Peep] = []

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

        var selectedIdx: Int? = nil
        var selectedPosition: CellPosition? = nil
    }

    enum Action {
        case modalDragged(dragHeight: CGFloat)
        case modalDragEnded(dragHeight: CGFloat)
        case peepCellTapped(idx: Int, position: CellPosition)
        case scrollUpButtonTapped
        case showPeepDetail
        case onAppear
        case modalScrollUp
        case modalScrollDown
        case startEntryAnimation(idx: Int, peeps: [Peep])
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .onAppear:
                state.peeps.append(contentsOf: [.stubPeep0, .stubPeep1, .stubPeep2, .stubPeep3, .stubPeep4, .stubPeep5])
                return .none

            case let .modalDragged(dragHeight):
                let newOffset = max(
                    min(state.modalOffset + dragHeight, State.SheetType.scrollDown.offset),
                    State.SheetType.scrollUp.offset
                )

                state.modalOffset = newOffset
                return .none

            case let .modalDragEnded(dragHeight):
                // 모달 올림 드래그
                if dragHeight < 0 {
                    if dragHeight < -60 {
                        return .send(.modalScrollUp)
                    } else {
                        return .send(.modalScrollDown)
                    }
                } else { // 모달 내림 드래그
                    if dragHeight > 60 {
                        return .send(.modalScrollDown)
                    } else {
                        return .send(.modalScrollUp)
                    }
                }

            case let .peepCellTapped(idx, position):
                state.selectedIdx = idx
                state.selectedPosition = position
                let peeps = state.peeps
                
                return .run { send in
                    try await Task.sleep(for: .seconds(0.05))
                    await send(
                        .startEntryAnimation(idx: idx, peeps: peeps),
                        animation: .linear(duration: 0.1)
                    )
                }

            case .startEntryAnimation:
                state.showPeepDetail = true

                return .run { send in
                    try await Task.sleep(for: .seconds(0.1))
                    await send(.showPeepDetail)
                }

            case .scrollUpButtonTapped:
                return .send(.modalScrollUp)

            case .showPeepDetail:
                return .none

            case .modalScrollUp:
                state.modalOffset = State.SheetType.scrollUp.offset
                return .none

            case .modalScrollDown:
                state.modalOffset = State.SheetType.scrollDown.offset
                return .none
            }
        }
    }
}

