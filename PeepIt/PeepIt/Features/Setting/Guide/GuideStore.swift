//
//  GuideStore.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GuideStore {

    @ObservableState
    struct State: Equatable {

        enum GuideType: String, CaseIterable {
            case service = "서비스 이용 약관"
            case privacy = "개인 정보 처리 방침"
            case openSource = "오픈 소스 라이선스"

            
        }
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
