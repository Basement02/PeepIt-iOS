//
//  TermStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TermStore {

    @ObservableState
    struct State: Equatable {
        var serviceTermAgreed = false
        var locationTermAgreed = false
        var privacyTermAgreed = false
        var marcketingTermAgreed = false

        subscript(termType: TermType) -> Bool {
            get {
                switch termType {
                case .service:
                    return serviceTermAgreed
                case .location:
                    return locationTermAgreed
                case .privateInfo:
                    return privacyTermAgreed
                case .marcketing:
                    return marcketingTermAgreed
                }
            }
            set {
                switch termType {
                case .service:
                    serviceTermAgreed = newValue
                case .location:
                    locationTermAgreed = newValue
                case .privateInfo:
                    privacyTermAgreed = newValue
                case .marcketing:
                    marcketingTermAgreed = newValue
                }
            }
        }

        var isNextButtonActivated: Bool {
            return serviceTermAgreed && locationTermAgreed && privacyTermAgreed
        }

        var isAllAgreed = false
    }

    enum Action {
        case nextButtonTapped
        case allAgreeButtonTapped
        case termToggled(TermType)
        case backButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {

        Reduce { state, action in
            switch action {

            case .nextButtonTapped:
                return .none

            case .allAgreeButtonTapped:
                TermType.allCases.forEach { state[$0] = !state.isAllAgreed }
                state.isAllAgreed.toggle()
                
                return .none

            case let .termToggled(term):
                state[term].toggle()
                return .none

            case .backButtonTapped:
                return .run { _ in
                     await self.dismiss()
                 }
            }
        }
    }
}
