//
//  DraggableText.swift
//  PeepIt
//
//  Created by 김민 on 10/15/24.
//

import SwiftUI
import ComposableArchitecture

struct DraggableText: View {
    let textItem: TextItem
    let store: StoreOf<EditStore>

    @State private var offset: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0


    var body: some View {
        GeometryReader { geometry in
            WithPerceptionTracking {
                Text(textItem.text)
//                    .frame(
//                        width: 100 * currentScale,
//                        height: 100 * currentScale
//                    )
                    .font(.system(size: 14 * currentScale))
                    .position(
                        x: textItem.position.x + offset.width,
                        y: textItem.position.y + offset.height
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                store.send(.binding(.set(\.editMode, .editMode)))
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                let newPosition = CGPoint(
                                    x: textItem.position.x + offset.width,
                                    y: textItem.position.y + offset.height
                                )

                                store.send(
                                    .updateTextPosition(
                                        textId: textItem.id,
                                        position: newPosition
                                    )
                                )
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
                                // TODO: 글씨 크기 고민
                                store.send(.updateTextScale(textId: textItem.id, scale: finalScale))
                            }
                    )
                    .onAppear {
                        let centerX = geometry.size.width / 2
                        let centerY = geometry.size.height / 2

                        store.send(
                            .updateTextPosition(
                                textId: textItem.id,
                                position: CGPoint(x: centerX, y: centerY))
                        )
                    }
            }
        }
    }
}

#Preview {
    DraggableText(
        textItem: .init(text: "테스트 입력"),
        store: .init(initialState: EditStore.State()) { EditStore() }
    )
}

