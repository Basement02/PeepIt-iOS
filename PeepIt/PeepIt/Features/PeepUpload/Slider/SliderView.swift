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
            ZStack(alignment: .bottom) {
                Image("ScrollBar")

                Image("ScrollIndicator")
                    .offset(y: store.dragOffset - 210)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                store.send(.dragSlider(newHeight: gesture.translation.height))
                            }
                            .onEnded { _ in
                                store.send(.dragEnded)
                            }
                    )
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    SliderView(
        store: .init(initialState: SliderStore.State()) { SliderStore() }
    )
}
