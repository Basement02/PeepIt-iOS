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
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.text):
                return .none

            default:
                return .none
            }
        }
    }
}

