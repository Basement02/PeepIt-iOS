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
            return modalOffset == SheetType.scrollDown.offset
        }
        var modalOffset = CGFloat(SheetType.scrollDown.offset)
        var showPeepDetail = false
        var currentIdx = 0
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

    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case modalDragged(dragHeight: CGFloat)
        case modalDragEnded(dragHeight: CGFloat)
        case peepCellTapped(idx: Int, peeps: [Peep])
        case scrollUpButtonTapped
        case showPeepDetail
        case onAppear
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.currentIdx):
                return .none

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
                        state.modalOffset = State.SheetType.scrollUp.offset
                    } else {
                        state.modalOffset = State.SheetType.scrollDown.offset
                    }
                } else { // 모달 내림 드래그
                    if dragHeight > 60 {
                        state.modalOffset = State.SheetType.scrollDown.offset
                    } else {
                        state.modalOffset = State.SheetType.scrollUp.offset
                    }
                }

                return .none

            case .peepCellTapped:
                state.showPeepDetail = true

                return .run { send in
                    try await Task.sleep(for: .seconds(0.1))
                    await send(.showPeepDetail)
                }

            case .scrollUpButtonTapped:
                state.modalOffset = State.SheetType.scrollUp.offset
                return .none

            case .showPeepDetail:
                return .none

            default:
                return .none
            }
        }
    }
}

