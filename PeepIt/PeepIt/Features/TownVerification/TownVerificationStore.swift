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
        /// 현재 중심 좌표의 동네 이름
        var townName: String?
        /// 맵 인터렉션 상태
        var mapInteraction: MapInteractionState = .idle
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
        case moveToCurrentButtonTapped

        /// 법정동 코드 조회 (카카오 로컬 api)
        case getLegalCode(loc: Coordinate)
        case fetchGetLegalCodeResult(Result<TownInfo?, Error>)

        /// 동네 등록 api
        case modifyUserTown(bCode: String)
        case fetchModifyUserTownResult(Result<Void, Error>)

        /// 동네 수정 시 프로필 수정
        case updateProfile(town: String, bCode: String)
    }

    @Dependency(\.userProfileStorage) var userProfileStorage
    @Dependency(\.townAPIClient) var townAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
                
            case .binding(\.centerLoc):
                let newCoord = state.centerLoc
                return .send(.getLegalCode(loc: newCoord))

            case .binding(\.mapInteraction):
                return .none

            case .registerButtonTapped:
                state.isSheetVisible = true
                return .none

            case .backButtonTapped:
                state.isSheetVisible = false
                state.mapInteraction = .idle
                return .none

            case .dismissButtonTapped:
                state.isSheetVisible = false
                state.mapInteraction = .idle
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

            case .moveToCurrentButtonTapped:
                state.mapInteraction = .resetRequested
                return .none

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
                    guard let townInfo = value else { return .none }
                    
                    state.currentBCode = townInfo.bCode
                    state.townName = townInfo.address

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
                    guard let townName = state.townName,
                          let bCode = state.currentBCode else { return .none }

                    return .concatenate(
                        .send(.updateProfile(town: townName, bCode: bCode)),
                        .send(.dismissButtonTapped)
                    )

                case let .failure(error):
                    if error.asPeepItError() == .bCodeError {
                        print("법정동 오류")
                        // TODO: - 오류 처리(UI 수정)
                    }
                    
                    return .none
                }

            case let .updateProfile(town, bCode):
                return .run { send in
                    var profile = (try await userProfileStorage.load())
                    profile?.townInfo = .init(address: town, bCode: bCode)

                    if let newProfile = profile {
                        try await userProfileStorage.save(newProfile)
                    }
                }

            default:
                return .none
            }
        }
    }
}
