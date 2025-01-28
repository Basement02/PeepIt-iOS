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
        var nickname = "기존 닉네임"
        var gender: GenderType = .man
        var nicknameField = ""
        var selectedGender: GenderType? = nil
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case nicknameButtonTapped
        case genderButtonTapped
        case saveButtonTapped
        case selectGender(GenderType)
        case nicknameModifyButtonTapped
        case genderModifyButtonTapped
        case dismiss
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.nicknameField):
                print(state.nicknameField)
                return .none

            case .backButtonTapped:
                return .send(.dismiss)

            case .nicknameButtonTapped:
                return .none

            case .genderButtonTapped:
                return .none

            case let .selectGender(type):
                if type == state.selectedGender {
                    state.selectedGender = nil
                } else {
                    state.selectedGender = type
                }

                return .none

            case .saveButtonTapped:
                return .send(.dismiss)

            case .nicknameModifyButtonTapped:
                return .none

            case .genderModifyButtonTapped:
                return .none

            case .dismiss:
                return .run { _ in await self.dismiss() }

            default:
                return .none
            }
        }
    }
}
