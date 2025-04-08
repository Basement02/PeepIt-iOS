//
//  TownVerificationStore.swift
//  PeepIt
//
//  Created by 김민 on 2/3/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TownVerificationStore {

    @ObservableState
    struct State: Equatable {
        var isSheetVisible = false
        var modalOffset = Constant.screenHeight

        /// 지도의 중심 좌표
        var centerLoc = Coordinate(x: 0, y: 0)
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case modalDragOnChanged(height: CGFloat)
        case registerButtonTapped
        case backButtonTapped
        case dismissButtonTapped
        case closeModal
        case viewTapped

        /// 법정동 코드 조회 (카카오 로컬 api)
        case getLegalCode(loc: Coordinate)
        case fetchGetLegalCodeResult(Result<LegalCode?, Error>)
    }
    
    @Dependency(\.townAPIClient) var townAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.centerLoc):
                return .none

            case .registerButtonTapped:
                state.isSheetVisible = true
                return .none

            case .backButtonTapped:
                state.isSheetVisible = false
                return .none

            case .dismissButtonTapped:
                state.isSheetVisible = false
                return .send(.closeModal)

            case let .modalDragOnChanged(height):
                state.modalOffset = height
                return .none

            case .closeModal:
                state.modalOffset = Constant.screenHeight
                return .none

            case .viewTapped:
                return .send(.closeModal)

            case let .getLegalCode(loc):
                print(loc)
                
                return .none

            case let .fetchGetLegalCodeResult(result):
                switch result {
                case let .success(value):
                    print(value)

                case let .failure(error):
                    print(error)
                    // TODO: 에러 처리
                }
                return .none

            default:
                return .none
            }
        }
    }
}
