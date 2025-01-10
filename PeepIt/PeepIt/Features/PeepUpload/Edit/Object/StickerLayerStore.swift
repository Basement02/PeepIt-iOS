//
//  StickerLayerStore.swift
//  PeepIt
//
//  Created by 김민 on 1/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StickerLayerStore {

    @ObservableState
    struct State: Equatable {
        /// 보여줄 스티커들
        var stickers: [StickerItem] = []
    }

    enum Action {
        /// 초기 스티커 위치 세팅
        case setInitialStickerPosition(id: UUID, position: CGPoint)
        /// 스티커 위치 세팅
        case updateStickerPosition(id: UUID, position: CGPoint)
        /// 스티커 드래그
        case stickerDragged(id: UUID, loc: CGPoint)
        /// 스티커 드래그 끝
        case stickerDragEnded(id: UUID)
        /// 스티커 롱프레스
        case stickerLongTapped
        /// 스티커 롱프레스 끝
        case stickerLongTapEnded
        /// 스티커 크기 업데이트
        case updateStickerScale(id: UUID, scale: CGFloat)
        /// 스티커 크기 업데이트 끝
        case scaleUpdateEnded
    }

    var body: Reduce<State, Action> {
        Reduce { state, action in
            switch action {

            case let .setInitialStickerPosition(id, position):
                return .send(.updateStickerPosition(id: id, position: position))

            case let .updateStickerPosition(id, position):
                guard let idx = state.stickers.firstIndex(
                    where: { $0.id == id }
                ) else { return .none }

                state.stickers[idx].position = position
                return .none

            case let .stickerDragged(id, loc):
                return .send(.updateStickerPosition(id: id, position: loc))

            case .stickerDragEnded:
                return .none

            case .stickerLongTapped:
                return .none

            case .stickerLongTapEnded:
                return .none

            case let .updateStickerScale(id, scale):
                guard let idx = state.stickers.firstIndex(
                    where: { $0.id == id }
                ) else { return .none }

                state.stickers[idx].scale = scale
                return .none

            case .scaleUpdateEnded:
                return .none
            }
        }
    }
}
