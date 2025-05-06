//
//  HomeMapStore.swift
//  PeepIt
//
//  Created by 김민 on 5/2/25.
//

import ComposableArchitecture
import UIKit

@Reducer
struct HomeMapStore {

    @ObservableState
    struct State: Equatable {
        /// 좌표의 중앙 파악
        var centerCoord = Coordinate(x: 0, y: 0)
        /// 첫 번째 등장인지 체크
        var isFirstSearching = true
        /// 지도 위의 핍들
        var mapPeeps: [Peep] = []
        /// 드래그 여부 파악(이 동네에서 검색 버튼 띄움)
        var isDragged = false
        /// 현재 위치로 돌아가기
        var moveToCurrentLoc = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 중앙 좌표 업데이트
        case updateCenter
        /// 이 지도에서 검색 탭
        case searchButtonTapped
        /// 현재 위치로 돌아가기
        case locationButtonTapped
        /// 드래그 시 모달 내리기
        case closePreviewModal
        /// 지도 api 호출하기
        case getMapPeepsFromCenterCoord(coord: Coordinate)
    }

    @Dependency(\.peepAPIClient) var peepAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.centerCoord):
                return .none

            case .binding(\.isDragged):
                guard state.isDragged else { return .none }

                return .send(.closePreviewModal)

            case .updateCenter:
                guard state.isFirstSearching else { return .none }

                state.isFirstSearching = false

                return .send(.getMapPeepsFromCenterCoord(coord: state.centerCoord))

            case .searchButtonTapped:
                state.isDragged = false
                
                return .send(.getMapPeepsFromCenterCoord(coord: state.centerCoord))

            case .locationButtonTapped:
                state.moveToCurrentLoc = true
                state.isDragged = true

                return .none

            case .closePreviewModal:
                return .none

            case .getMapPeepsFromCenterCoord:
                return .none

            default:
                return .none
            }
        }
    }
}
