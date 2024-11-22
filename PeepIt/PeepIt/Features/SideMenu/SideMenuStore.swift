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

        var isSettingHold = false
    }

    enum Action {
        case dismissSideMenu
        case menuTapped(of: SideMenuType)

        case settingHoldStart
        case settingHoldStop
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .dismissSideMenu:
                state.sideMenuOffset = -Constant.screenWidth
                return .none

            case .menuTapped:
                return .none

            case .settingHoldStart:
                state.isSettingHold = true
                return .none

            case .settingHoldStop:
                state.isSettingHold = false
                return .none
            }
        }
    }
}
