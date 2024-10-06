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
        var nickname = ""
        var validState = NicknameValidation.base

        enum NicknameValidation {
            case base
            case minCount
            case maxCount
            case validated
            case wrongWord

            var message: String {
                switch self {
                case .base:
                    return "기본"
                case .minCount:
                    return "더 입력"
                case .maxCount:
                    return "덜 입력"
                case .validated:
                    return "사용 가능"
                case .wrongWord:
                    return "사용 불가"
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
            case .binding(\.nickname):
                if state.nickname.count > 1 {
                    state.validState = .validated
                } else {
                    state.validState = .base
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
