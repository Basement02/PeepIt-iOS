//
//  SideMenuStore.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SideMenuStore {
    
    @ObservableState
    struct State: Equatable {
        var sideMenuOffset = -CGFloat(318)
    }

    enum Action {
        case notificationMenuTapped
        case logoutButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .notificationMenuTapped:
                return .none

            case .logoutButtonTapped:
                return .none
            }
        }
    }
}
