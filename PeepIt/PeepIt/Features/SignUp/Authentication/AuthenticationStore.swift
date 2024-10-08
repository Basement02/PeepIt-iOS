//
//  AuthenticationStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AuthenticationStore {

    @ObservableState
    struct State: Equatable {
        var phoneNumber = "01012345678"
        var isAuthProcessReady = false
        var isSMSAuthProcess = false
        var code = Array(repeating: "", count: 6)
        var focused: CodeField? = nil

        enum CodeField: Int, Hashable {
            case first, second, third, fourth, fifth, sixth
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case bottomButtonTapped(isStartAuthButton: Bool)
        case phoneNumberLabelTapped
        case resendCodeButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.phoneNumber):
                state.isAuthProcessReady = state.phoneNumber.count == 11
                return .none
                
            case let .bottomButtonTapped(isStartAuthButton):
            if state.isAuthProcessReady { state.isSMSAuthProcess = true }
                return .none

            case .phoneNumberLabelTapped:
                state.isSMSAuthProcess = false
                return .none

            case .resendCodeButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}
