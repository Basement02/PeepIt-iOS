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
    }

    enum Action {
        case nicknameButtonTapped
        case genderButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nicknameButtonTapped:
                return .none

            case .genderButtonTapped:
                return .none
            }
        }
    }
}
