//
//  NicknameStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

/// 닉네임 유효성 검증 enum
enum NicknameValidation {
    case base
    case maxCount
    case validated
    case wrongWord

    var message: String {
        switch self {
        case .base:
            return "한문 및 영문만 사용 가능합니다."
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

@Reducer
struct NicknameStore {

    @ObservableState
    struct State: Equatable {
        /// 닉네임 바인딩 변수
        var nickname = ""
        /// 입력창 상태
        var enterState = EnterState.base
        /// 가이드메세지
        var guideMessage = NicknameValidation.base.message

        @Shared(.inMemory("userInfo")) var userInfo: UserInfo = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 다음 버튼 탭
        case nextButtonTapped
        /// 뷰 나타날 때
        case onAppeared
        /// 뒤로가기 버튼 탭
        case backButtonTapped
        /// 닉네임 텍스트 디바운싱
        case debouncedText(newText: String)
    }

    enum ID: Hashable {
        case debounce
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
            .onChange(of: \.nickname) { _, newValue in
                Reduce { state, action in
                    return .run { send in
                        await send(.debouncedText(newText: newValue))
                    }
                    .debounce(
                        id: ID.debounce,
                        for: 0.2,
                        scheduler: DispatchQueue.main
                    )
                }
            }

        Reduce { state, action in
            switch action {

            case .binding(\.nickname):
                return .none

            case .nextButtonTapped:
                state.userInfo.nickname = state.nickname
                return .none

            case .onAppeared:
                return .none

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case let .debouncedText(newText):
                let validState = validateNickname(newText)
                state.enterState = validState.enterState
                state.guideMessage = validState.message
                return .none

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
