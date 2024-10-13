//
//  EditStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EditStore {

    @ObservableState
    struct State: Equatable {

        @Presents var stickerModalState: StickerModalStore.State?
    }

    enum Action {
        case soundOnOffButtonTapped
        case stickerButtonTapped
        case textButtonTapped
        case uploadButtonTapped
        case stickerListAction(PresentationAction<StickerModalStore.Action>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .soundOnOffButtonTapped:
                return .none

            case .stickerButtonTapped:
                state.stickerModalState = .init()
                return .none

            case .textButtonTapped:
                return .none

            case .uploadButtonTapped:
                return .none

            case .stickerListAction:
                state.stickerModalState = nil
                return .none
            }
        }
        .ifLet(\.$stickerModalState, action: \.stickerListAction) {
            StickerModalStore()
        }
    }
}
