//
//  AnnounceStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AnnounceStore {

    @ObservableState
    struct State: Equatable {
        /// 공지 목록
        var announces: [Announce] = [.announce1, .announce2]
        /// 선택된 공지
        var selectedAnnounce: Announce?
        /// modal 올리기 여부
        var isSheetVisible = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case announceTapped(announce: Announce)
        case showSheet
        case closeSheet
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .backButtonTapped:
                return .run { _ in
                     await self.dismiss()
                }

            case let .announceTapped(announce):
                state.selectedAnnounce = announce
                return .send(.showSheet)

            case .showSheet:
                state.isSheetVisible = true
                return .none

            case .closeSheet:
                state.isSheetVisible = false
                return .none

            default:
                return .none
            }
        }
    }
}
