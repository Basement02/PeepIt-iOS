//
//  NicknameStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct NicknameStore {

    @ObservableState
    struct State: Equatable {
        /// 닉네임 바인딩 변수
        var nickname = ""

        /// 닉네임 유효성 검증 상태
        var nicknameValidation = NicknameValidation.base

        /// 입력창 히위 뷰 State
        var enterFieldState = CheckEnterFieldStore.State()

        @Shared(.inMemory("userInfo")) var userInfo: UserInfo = .init()
    }

    enum Action {
        /// 다음 버튼 탭
        case nextButtonTapped
        /// 하위뷰 액션 연결
        case enterFieldAction(CheckEnterFieldStore.Action)
        /// 뷰 나타날 때
        case onAppeared
        /// 뒤로가기 버튼 탭
        case backButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Scope(state: \.enterFieldState, action: \.enterFieldAction) {
            CheckEnterFieldStore()
        }

        Reduce { state, action in
            switch action {
            case .enterFieldAction(.binding(\.text)):
                state.nicknameValidation = validateNickname(state.enterFieldState.text)

                state.enterFieldState.enterState = state.nicknameValidation.enterState
                state.enterFieldState.message = state.nicknameValidation.message

                return .none
                
            case .nextButtonTapped:
                state.userInfo.nickname = state.enterFieldState.text
                return .none

            case .onAppeared:
                state.enterFieldState.fieldType = CheckEnterFieldStore.State.FieldType.nickname
                state.enterFieldState.message = state.nicknameValidation.message

                return .none

            case .backButtonTapped:
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
        case !nickname.isValidForWords:
            return .wrongWord
        case nickname.count > 18:
            return .maxCount
        default:
            return .validated
        }
    }
}
