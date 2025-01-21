//
//  HomeStore.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeStore {

    @ObservableState
    struct State: Equatable {
        var isPeepDetailShowed = false
        var peepPreviewModal = PeepModalStore.State()
        var peepDetail = PeepDetailStore.State()
        var sideMenu = SideMenuStore.State()
        var camera = CameraStore.State()
    }

    enum Action {
        case goToPeepTapped
        case sideMenuButtonTapped
        case profileButtonTapped
        case uploadButtonTapped

        case peepDetail(PeepDetailStore.Action)
        case sideMenu(SideMenuStore.Action)
        case peepPreviewModal(PeepModalStore.Action)
        case camera(CameraStore.Action)

        case pushToDetail
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.peepPreviewModal, action: \.peepPreviewModal) {
            PeepModalStore()
        }

        Scope(state: \.sideMenu, action: \.sideMenu) {
            SideMenuStore()
        }
        
        Reduce { state, action in
            switch action {

            case .goToPeepTapped:
                state.isPeepDetailShowed = true
                return .none

            case .sideMenuButtonTapped:
                state.sideMenu.sideMenuOffset = 0
                return .none

            case .profileButtonTapped:
                return .none

            case .uploadButtonTapped:
                return .none

            case .peepPreviewModal(.peepCellTapped):
                return .send(.pushToDetail)

            case .pushToDetail:
                return .none

            default:
                return .none
            }
        }
    }
}
