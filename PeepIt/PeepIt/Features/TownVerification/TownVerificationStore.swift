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
        /// 동네 등록 모달 노출 여부
        var isSheetVisible = false
        /// 모달 오프셋 관리
        var modalOffset = Constant.screenHeight
        /// 지도의 중심 좌표
        var centerLoc = Coordinate(x: 0, y: 0)
        /// 현재 중심 좌표의 법정동 코드
        var currentBCode: String?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case modalDragOnChanged(height: CGFloat)
        case registerButtonTapped
        case backButtonTapped
        case dismissButtonTapped
        case closeModal
        case viewTapped
        case townVerifyButtonTapped

        /// 법정동 코드 조회 (카카오 로컬 api)
        case getLegalCode(loc: Coordinate)
        case fetchGetLegalCodeResult(Result<LegalCode?, Error>)

        /// 동네 등록 api
        case modifyUserTown(bCode: String)
        case fetchModifyUserTownResult(Result<Void, Error>)
    }
    
    @Dependency(\.townAPIClient) var townAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.centerLoc):
                let newCoord = state.centerLoc
                return .send(.getLegalCode(loc: newCoord))

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

            case .townVerifyButtonTapped:
                guard let bCode = state.currentBCode else { return .none }
                return .send(.modifyUserTown(bCode: bCode))

            case let .getLegalCode(loc):
                return .run { send in
                    await send(
                        .fetchGetLegalCodeResult(
                            Result { try await townAPIClient.getTownLegalCode(loc) }
                        )
                    )
                }

            case let .fetchGetLegalCodeResult(result):
                switch result {

                case let .success(value):
                    guard let legalCode = value else { return .none }
                    state.currentBCode = legalCode.code
                    return .none

                case let .failure(error):
                    // TODO: 에러처리
                    print(error)
                    return .none
                }

            case let .modifyUserTown(bCode):
                return .run { send in
                    await send(
                        .fetchModifyUserTownResult(
                            Result { try await townAPIClient.modifyUserTown(bCode) }
                        )
                    )
                }

            case let .fetchModifyUserTownResult(result):
                switch result {

                case .success:
                    return .send(.dismissButtonTapped)

                case .failure:
                    // TODO: 에러처리
                    return .none
                }

            default:
                return .none
            }
        }
    }
}
