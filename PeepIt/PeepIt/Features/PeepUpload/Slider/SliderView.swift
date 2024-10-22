//
//  SliderView.swift
//  PeepIt
//
//  Created by 김민 on 10/21/24.
//

import SwiftUI
import ComposableArchitecture

struct SliderView: View {
    let store: StoreOf<SliderStore>

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { geo in
                WithPerceptionTracking {
                    let height = geo.size.height

                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 5, height: height)

                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(.black)
                                .frame(width: 11, height: 20)

                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.clear)
                                .frame(
                                    width: 5,
                                    height: height * (store.value - store.range.lowerBound) / (store.range.upperBound - store.range.lowerBound)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let newValue = (height - value.location.y) / height
                                store.send(
                                    .setSliderValue(
                                        newValue: newValue,
                                        lowerBound: store.range.lowerBound,
                                        upperBound: store.range.upperBound
                                    )
                                )
                            }
                    )
                }
            }
        }
    }
}

#Preview {
    SliderView(
        store: .init(initialState: SliderStore.State()) { SliderStore() }
    )
}
