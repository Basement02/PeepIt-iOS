//
//  CheckEnterFieldStore.swift
//  PeepIt
//
//  Created by 김민 on 10/31/24.
//

import Foundation
import ComposableArchitecture

enum EnterState: Equatable {
    case base
    case completed
    case error
}

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
struct CheckEnterFieldStore {

    @ObservableState
    struct State: Equatable {
        var text = ""
        var message = "가이드 문구"
        var enterState = EnterState.base
        var fieldType = FieldType.id

        enum FieldType: String, Equatable {
            case id = "아이디"
            case nickname = "닉네임"

            var placeholder: String {
                switch self {
                case .id: return "아이디를 입력해주세요."
                case .nickname: return "닉네임을 입력해주세요."
                }
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case debouncedText(newText: String)
    }

    enum ID: Hashable {
        case debounce
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
            .onChange(of: \.text) { oldValue, newValue in
                Reduce { state, action in
                    return .run(operation: { send in
                        await send(.debouncedText(newText: newValue))
                    })
                    .debounce(
                        id: ID.debounce,
                        for: 0.5,
                        scheduler: DispatchQueue.main
                    )
                }
            }

        Reduce { state, action in
            switch action {
            case .binding(\.text):
                return .none

            case .debouncedText:
                return .none

            default:
                return .none
            }
        }
    }
}

