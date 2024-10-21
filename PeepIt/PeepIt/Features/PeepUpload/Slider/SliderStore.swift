//
//  SliderStore.swift
//  PeepIt
//
//  Created by 김민 on 10/21/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SliderStore {

    @ObservableState
    struct State: Equatable {
        var value: CGFloat = 24
        var range: ClosedRange<CGFloat> = 4...100
    }

    enum Action {
        case setSliderValue(newValue: CGFloat, lowerBound: CGFloat, upperBound: CGFloat)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case let .setSliderValue(newValue, lowerBound, upperBound):
                let finalValue = lowerBound + newValue * (upperBound - lowerBound)
                state.value = min(max(finalValue, lowerBound), upperBound)
                return .none
            }
        }
    }
}
