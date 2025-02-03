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
        /// 삭제 영역
        var deleteRect = CGRect.zero
        /// 삭제 영역에 들어간 스티커 체크 - 삭제 및 크기 관리 위함
        var stickersInDeleteArea: Set<UUID> = []
        /// 삭제 영역에 들어갔는지
        var isDeleteAreaActive = false
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


                let size = 120 * state.stickers[idx].scale

                let stickerRect = CGRect(
                    x: position.x - size/2,
                    y: position.y - size/2,
                    width: size,
                    height: size
                )

                if stickerRect.intersects(state.deleteRect) {
                    state.stickersInDeleteArea.insert(id)
                    state.isDeleteAreaActive = true
                } else {
                    state.stickersInDeleteArea.remove(id)
                    state.isDeleteAreaActive = false
                }

                return .none

            case let .stickerDragged(id, loc):
                return  .send(.updateStickerPosition(id: id, position: loc))

            case let .stickerDragEnded(id):
                if state.stickersInDeleteArea.contains(id) {
                    state.stickers.removeAll { $0.id == id }
                    state.stickersInDeleteArea.remove(id)
                }
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
