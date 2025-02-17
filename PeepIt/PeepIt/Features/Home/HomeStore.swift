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
        var townVerificationModalOffset = Constant.screenHeight
        var peepPreviewModal = PeepModalStore.State()
        var peepDetail = PeepDetailStore.State()
        var sideMenu = SideMenuStore.State()
        var camera = CameraStore.State()
        var townVerification = TownVerificationStore.State()
        var showTownVeriModal = false

        var mainViewOffset = CGFloat.zero

        var showPeepDetail = false
        var selectedPeepIndex: Int? = nil
        var mainViewMoved = false
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
        case townVerification(TownVerificationStore.Action)

        case pushToDetail
        case addressButtonTapped
        case dismissSideMenu
        case showMainViewBg
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.peepPreviewModal, action: \.peepPreviewModal) {
            PeepModalStore()
        }

        Scope(state: \.sideMenu, action: \.sideMenu) {
            SideMenuStore()
        }

        Scope(state: \.townVerification, action: \.townVerification) {
            TownVerificationStore()
        }

        Scope(state: \.peepDetail, action: \.peepDetail) {
            PeepDetailStore()
        }

        Reduce { state, action in
            switch action {

            case .goToPeepTapped:
                state.isPeepDetailShowed = true
                return .none

            case .sideMenuButtonTapped:
                state.sideMenu.sideMenuOffset = 0
                state.mainViewOffset = CGFloat(318)
                return .none

            case .profileButtonTapped:
                return .none

            case .uploadButtonTapped:
                return .none

            case let .peepPreviewModal(.peepCellTapped(idx)):
                state.showPeepDetail = true
                state.selectedPeepIndex = idx

                return .none

            case .peepPreviewModal(.showPeepDetail):
                state.peepDetail.showPeepDetailObject = true
                return .none

            case .pushToDetail:
                return .none

            case .addressButtonTapped:
                state.showTownVeriModal = true
                state.townVerificationModalOffset = 0
                return .none

            case let .townVerification(.modalDragOnChanged(height)):
                state.townVerificationModalOffset = height
                return .none

            case .townVerification(.closeModal):
                state.showTownVeriModal = false
                state.townVerificationModalOffset = Constant.screenHeight
                return .none

            case .peepDetail(.backButtonTapped):
                state.showPeepDetail = false
                state.selectedPeepIndex = nil
                state.peepPreviewModal.showPeepDetail = false
                return .none

            case .dismissSideMenu:
                state.mainViewMoved = false
                state.sideMenu.sideMenuOffset = -CGFloat(318)
                state.mainViewOffset = 0
                return .none

            case .showMainViewBg:
                state.mainViewMoved = true
                return .none

            default:
                return .none
            }
        }
    }
}
