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
        var id = "id"
        var nickname = "nickname"
        var gender: GenderType = .man
        var nicknameField = ""
        var selectedGender: GenderType = .man
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case bind
        case nicknameButtonTapped
        case genderButtonTapped
        case selectGender(of: GenderType)
        case nicknameModifyButtonTapped
        case genderModifyButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.nicknameField):
                print(state.nicknameField)
                return .none

            case .nicknameButtonTapped:
                return .none

            case .genderButtonTapped:
                return .none

            case let .selectGender(type):
                state.selectedGender = type
                return .none

            case .nicknameModifyButtonTapped:
                return .none

            case .genderModifyButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}
