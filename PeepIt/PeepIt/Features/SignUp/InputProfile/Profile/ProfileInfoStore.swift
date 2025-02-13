//
//  ProfileInfoStore.swift
//  PeepIt
//
//  Created by 김민 on 10/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileInfoStore {

    @ObservableState
    struct State: Equatable {
        var nickname = ""
        var date = ""
        var selectedGender: GenderType?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectedGender(GenderType)
        case nextButtonTapped
        case backButtonTapped
        case dateDebounced(String)
    }

    enum ID: Hashable {
        case debounce
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.date):
                let date = state.date

                return .run { send in
                    await send(.dateDebounced(date))
                }
                .debounce(id: ID.debounce, for: 0.003, scheduler: DispatchQueue.main)

            case let .selectedGender(gender):
                state.selectedGender = state.selectedGender == gender ? nil : gender
                return .none

            case .nextButtonTapped:
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }

            case let .dateDebounced(date):
                let digits = date.filter { $0.isNumber }
                if digits.count == 4 || digits.count == 6 { state.date.append(".") }

                return .none

            default:
                return .none
            }
        }
    }
}
