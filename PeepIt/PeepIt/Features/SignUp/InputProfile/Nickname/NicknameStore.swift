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

        /// 닉네임 유효성 검증 enum
        enum NicknameValidation {
            case base
            case maxCount
            case validated
            case wrongWord

            var message: String {
                switch self {
                case .base:
                    return "영문, 숫자 특수문자(_,-, .)만 사용 가능합니다."
                case .maxCount:
                    return "닉네임으로 사용하기에 너무 길어요 :("
                case .validated:
                    return "사용 가능한 닉네임입니다 :)"
                case .wrongWord:
                    return "사용할 수 없는 문자가 포함되어 있어요 :("
                }
            }

            var enterState: EnterState {
                switch self {
                case .base:
                    return .base
                case .validated:
                    return .completed
                default:
                    return .error
                }
            }
        }

        /// 입력창 히위 뷰 State
        var enterFieldState = CheckEnterFieldStore.State()
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
                return .none

            case .onAppeared:
                state.enterFieldState.content = "닉네임"
                state.enterFieldState.message = state.nicknameValidation.message

                return .none

            case .backButtonTapped:
                return .run { _ in
                     await self.dismiss()
                }

            default:
                return .none
            }
        }
    }

    func validateNickname(_ nickname: String) -> NicknameStore.State.NicknameValidation {
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
