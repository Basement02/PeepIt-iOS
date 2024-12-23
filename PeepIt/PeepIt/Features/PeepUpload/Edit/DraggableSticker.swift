//
//  DraggableSticker.swift
//  PeepIt
//
//  Created by 김민 on 10/15/24.
//

import SwiftUI
import ComposableArchitecture

struct DraggableSticker: View {
    let sticker: StickerItem
    let store: StoreOf<EditStore>

    @State private var offset: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            WithPerceptionTracking {
                Image(sticker.stickerName)
                    .resizable()
                    .frame(
                        width: 120 * currentScale,
                        height: 120 * currentScale
                    )
                    .position(
                        x: sticker.position.x + offset.width,
                        y: sticker.position.y + offset.height
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                store.send(.binding(.set(\.editMode, .editMode)))
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                let newPosition = CGPoint(
                                    x: sticker.position.x + offset.width,
                                    y: sticker.position.y + offset.height
                                )
                                store.send(.updateStickerPosition(stickerId: sticker.id, position: newPosition))
                                offset = .zero
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { scale in
                                store.send(.binding(.set(\.editMode, .editMode)))
                                currentScale = finalScale * scale
                            }
                            .onEnded { scale in
                                finalScale *= scale
                                store.send(.updateStickerScale(stickerId: sticker.id, scale: finalScale))
                            }
                    )
                    .onAppear {
                        let centerX = geometry.size.width / 2
                        let centerY = geometry.size.height / 2

                        store.send(
                            .updateStickerPosition(
                                stickerId: sticker.id,
                                position: CGPoint(x: centerX, y: centerY))
                        )
                    }
            }
        }
    }
}

#Preview {
    DraggableSticker(
        sticker: .init(stickerName: "😄"),
        store: .init(initialState: EditStore.State()) { EditStore() }
    )
}
