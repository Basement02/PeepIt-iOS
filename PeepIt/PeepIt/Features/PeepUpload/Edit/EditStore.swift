//
//  EditStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import Foundation
import ComposableArchitecture

struct StickerItem: Identifiable, Equatable {
    var id = UUID()
    var stickerName = ""
    var position: CGPoint = .zero
}

@Reducer
struct EditStore {

    @ObservableState
    struct State: Equatable {

        var stickers: [StickerItem] = .init()

        @Presents var stickerModalState: StickerModalStore.State?
    }

    enum Action {
        case soundOnOffButtonTapped
        case stickerButtonTapped
        case textButtonTapped
        case uploadButtonTapped
        case stickerListAction(PresentationAction<StickerModalStore.Action>)
        case updateStickerPosition(stickerId: UUID, position: CGPoint)
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

            case let .stickerListAction(.presented(.stickerSelected(selectedSticker))):
                state.stickers.append(StickerItem(stickerName: selectedSticker.rawValue))
                state.stickerModalState = nil
                return .none

            case .updateStickerPosition:
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$stickerModalState, action: \.stickerListAction) {
            StickerModalStore()
        }
    }
}
