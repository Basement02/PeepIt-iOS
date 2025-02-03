//
//  TextLayerStore.swift
//  PeepIt
//
//  Created by 김민 on 1/13/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TextLayerStore {

    @ObservableState
    struct State: Equatable {
        /// 보여줄 텍스트들
        var textItems: [TextItem] = []
        /// 삭제 영역
        var deleteRect: CGRect = .zero
        /// 삭제 영역과 겹치는 텍스트
        var textInDeleteArea: Set<UUID> = []
        /// 텍스트 사이즈 저장 -> 삭제 영역과 겹치는지 확인
        var textSize: [UUID: CGSize] = [:]
        /// 수정을 위해 선택된 텍스트 (수정 중엔 원래 텍스트는 숨기기 위함)
        var selectedTextId: UUID?
        /// 삭제 영역에 들어갔는지
        var isDeleteAreaActive = false
    }

    enum Action {
        /// 초기 텍스트 위치 잡기
        case setInitialTextPosition(id: UUID, position: CGPoint)
        /// 텍스트 위치 업데이트 (드래그, 초기 세팅 등)
        case updateTextPosition(id: UUID, position: CGPoint)
        /// 텍스트 드래그 중
        case textDragged(id: UUID, loc: CGPoint)
        /// 텍스트 드래그 끝
        case textDragEnded(id: UUID)
        /// 텍스트 사이즈 측정
        case setTextSize(id: UUID, size: CGSize)
        /// 텍스트 롱탭 중
        case textLongerTapped
        /// 텍스트 롱탭 끝
        case textLongerTapEnded
        /// 텍스트 탭했을 때 -> 텍스트 수정 모드 진입
        case textTapped(textItem: TextItem)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setInitialTextPosition(id, position):
                return .send(.updateTextPosition(id: id, position: position))

            case let .updateTextPosition(id, position):
                guard let idx = state.textItems.firstIndex(
                    where: { $0.id == id }
                ) else { return .none }

                state.textItems[idx].position = position

                guard let textSize = state.textSize[id] else { return .none }

                let (w, h) = (textSize.width, textSize.height)

                let textRect = CGRect(
                    x: position.x - w/2,
                    y: position.y - h/2,
                    width: w,
                    height: h
                )

                if textRect.intersects(state.deleteRect) {
                    state.textInDeleteArea.insert(id)
                    state.isDeleteAreaActive = true
                } else {
                    state.textInDeleteArea.remove(id)
                    state.isDeleteAreaActive = false
                }

                return .none

            case let .textDragged(id, loc):
                return .send(.updateTextPosition(id: id, position: loc))

            case let .textDragEnded(id):
                guard state.textInDeleteArea.contains(id) else { return .none }

                state.textItems.removeAll { $0.id == id }
                state.textInDeleteArea.remove(id)
                
                return .none

            case let .setTextSize(id, size):
                state.textSize[id] = size
                return .none

            case .textLongerTapped,
                    .textLongerTapEnded:
                return .none

            case let .textTapped(textItem):
                state.selectedTextId = textItem.id
                return .none
            }
        }
    }
}

