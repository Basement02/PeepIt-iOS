//
//  InputIdStore.swift
//  PeepIt
//
//  Created by 김민 on 10/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct InputIdStore {

    @ObservableState
    struct State: Equatable {
        var id = ""
        var idState = NicknameValidation.base

        enum NicknameValidation {
            case base
            case minCount
            case maxCount
            case duplicated
            case validated

            var message: String {
                switch self {
                case .base:
                    return "영문, 숫자 특수문자(_,-, .)만 사용 가능합니다."
                case .minCount:
                    return "아이디로 사용하기에 너무 짧아요 :("
                case .maxCount:
                    return "아이디로 사용하기에 너무 길어요 :("
                case .duplicated:
                    return "이미 사용 중인 아이디입니다."
                case .validated:
                    return "사용 가능한 아이디입니다 :)"
                }
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.id):
                if state.id.count < 10 {
                    state.idState = .minCount
                } else if state.id.count > 20 {
                    state.idState = .maxCount
                } else { // TODO: 중복 조건 추가
                    state.idState = .validated
                }

                return .none

            case .nextButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}

