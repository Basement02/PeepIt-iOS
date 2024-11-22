//
//  SettingStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingStore {

    @ObservableState
    struct State: Equatable {

        enum ServiceTermType: String, CaseIterable {
            case alarm = "알림 설정"
            case guide = "이용 안내"
            case mail = "문의하기"

            func destinationState() -> RootStore.Path.State? {
                switch self {
                case .alarm:
                    return .guide(GuideStore.State())
                case .guide:
                    return .guide(GuideStore.State())
                case .mail:
                    return nil
                }
            }
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
