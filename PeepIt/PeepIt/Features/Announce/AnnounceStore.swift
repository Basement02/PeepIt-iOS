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
    }

    enum Action {
        case backButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .backButtonTapped:
                return .run { _ in
                     await self.dismiss()
                }
            }
        }
    }
}
