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
        var sideMenuOffset = -Constant.screenWidth
    }

    enum Action {
        case dismissSideMenu
        case settingButtonTapped
        case menuTapped(of: SideMenuType)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .dismissSideMenu:
                state.sideMenuOffset = -Constant.screenWidth
                return .none

            case .settingButtonTapped:
                return .none

            case let .menuTapped(type):
                return .none
            }
        }
    }
}
