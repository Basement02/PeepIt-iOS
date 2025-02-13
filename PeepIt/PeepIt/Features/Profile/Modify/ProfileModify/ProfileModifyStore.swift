//
//  ProfileModifyStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileModifyStore {

    @ObservableState
    struct State: Equatable {
        /// 기존 아이디
        var id = "id"
        /// 기존 닉네임
        var nickname = "nickname"
        /// 기존 성별
        var selectedGender: GenderType? = nil
        /// 닉네임 유효성 검증 상태
        var nicknameValidation = NicknameValidation.base
        /// 입력창 히위 뷰 State
        var enterFieldState = CheckEnterFieldStore.State()
    }

    enum Action {
        /// 나타날 때
        case onAppear
        /// 이전 버튼 탭
        case backButtonTapped
        /// 저장 버튼 탭
        case saveButtonTapped
        /// 성별 선택 시
        case selectGender(GenderType)
        /// 뷰 닫기
        case dismiss
        /// 하위뷰 액션 연결
        case enterFieldAction(CheckEnterFieldStore.Action)
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Scope(
            state: \.enterFieldState,
            action: \.enterFieldAction
        ) {
            CheckEnterFieldStore()
        }

        Reduce { state, action in
            switch action {

            case .onAppear:
                state.enterFieldState.fieldType = .nickname
                state.enterFieldState.text = state.nickname
                return .none

            case .enterFieldAction(.binding(\.text)):
                state.nicknameValidation = validateNickname(state.enterFieldState.text)
                state.enterFieldState.enterState = state.nicknameValidation.enterState
                state.enterFieldState.message = state.nicknameValidation.message

                return .none

            case .backButtonTapped:
                return .send(.dismiss)

            case let .selectGender(type):
                if type == state.selectedGender {
                    state.selectedGender = nil
                } else {
                    state.selectedGender = type
                }

                return .none

            case .saveButtonTapped:
                return .send(.dismiss)

            case .dismiss:
                return .run { _ in await self.dismiss() }

            default:
                return .none
            }
        }
    }

    func validateNickname(_ nickname: String) -> NicknameValidation {
        switch true {
        case nickname.isEmpty:
            return .base
        case !nickname.isValidForAllowedCharacters:
            return .wrongWord
        case nickname.count > 18:
            return .maxCount
        default:
            return .validated
        }
    }
}
