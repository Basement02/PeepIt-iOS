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
        /// 드래그 가능 범위
        var range: ClosedRange<CGFloat> = 4...100
        /// 슬라이더 값(폰트 값)
        var sliderValue: CGFloat = 24
        /// 드래그 오프셋 (인디케이터 위치 반영)
        var dragOffset: CGFloat = 0
        /// 드래그 종료 시 저장할 위치
        var accumulatedOffset: CGFloat = 0
    }

    enum Action {
        /// 슬라이더 나타날 때
        case onAppear
        /// 슬라이더 인디케이터 잡고 드래그할 때
        case dragSlider(newHeight: CGFloat)
        /// 드래그 끝났을 때
        case dragEnded
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in

            let maxHeight: CGFloat = 210
            let (maxValue, minValue) = (state.range.upperBound, state.range.lowerBound)

            switch action {
                
            case .onAppear:
                state.dragOffset = maxHeight - ((state.sliderValue - minValue) / (maxValue - minValue)) * maxHeight
                state.accumulatedOffset = state.dragOffset

                return .none

            case let .dragSlider(newHeight):
                let newOffset = state.accumulatedOffset + newHeight

                state.dragOffset = min(max(0, newOffset), maxHeight)
                state.sliderValue = ((maxHeight - state.dragOffset) / maxHeight) * (maxValue - minValue) + minValue

                return .none

            case .dragEnded:
                state.accumulatedOffset = state.dragOffset
                return .none
            }
        }
    }
}
