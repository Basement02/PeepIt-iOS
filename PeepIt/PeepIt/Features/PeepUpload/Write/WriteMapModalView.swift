//
//  WriteMapModalView.swift
//  PeepIt
//
//  Created by 김민 on 2/2/25.
//

import SwiftUI
import ComposableArchitecture

struct WriteMapModalView: View {
    @Perception.Bindable var store: StoreOf<WriteStore>

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear

            BackdropBlurView(bgColor: .base.opacity(0.9), radius: 1)
                .frame(width: 393, height: 457)
                .roundedCorner(20, corners: [.topLeft, .topRight])
                .overlay {
                    VStack(spacing: 21) {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.gray600)
                            .frame(width: 60, height: 5)
                            .padding(.top, 10)

//                        MapView(centerLoc: .constant(.init(x: 0, y: 0)))
//                            .frame(width: 361, height: 387)
//                            .clipShape(RoundedRectangle(cornerRadius: 14))

                        Spacer()
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                store.send(
                                    .modalDragOnChanged(height: value.translation.height)
                                )
                            }
                        }
                        .onEnded { value in
                            /// 100 초과 드래그 될 시 모달 내려감
                            if value.translation.height > 50 {
                                store.send(.closeModal)
                            } else {
                                store.send(.modalDragOnChanged(height: 0))
                            }
                        }
                )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WriteView(
        store: .init(initialState: WriteStore.State()) { WriteStore() }
    )
}
