//
//  TownPeepsStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TownPeepsStore {

    @ObservableState
    struct State: Equatable {
        var offsetY = CGFloat.zero
        var isRefreshing = false
        var rotateAngle = Double.zero
        var peeps: [Peep] = []
    }

    enum Action {
        case backButtonTapped
        case setInitialOffsetY(CGFloat)
        case refresh
        case refreshEnded
        case onAppear
        case peepCellTapped(idx: Int, peeps: [Peep])
        case uploadButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .backButtonTapped:
                return .run { _ in
                     await self.dismiss()
                }

            case let .setInitialOffsetY(offsetY):
                state.offsetY = offsetY
                return .none

            case .refresh:
                state.isRefreshing = true

                return .run { send in
                    let startTime = Date()
                    while Date().timeIntervalSince(startTime) < 3 { 
//                        await send(.updateRotation)
                        print("새로고침 중...")
                    }
                    await send(.refreshEnded, animation: .linear)
                }
                
            case .refreshEnded:
//                state.peeps = [.stubPeep0, .stubPeep1, .stubPeep2, .stubPeep3, .stubPeep4, .stubPeep5, .stubPeep6, .stubPeep7]

                state.isRefreshing = false
                return .none

            case .peepCellTapped:
                return .none

            case .uploadButtonTapped:
                return .none
            }
        }
    }
}
