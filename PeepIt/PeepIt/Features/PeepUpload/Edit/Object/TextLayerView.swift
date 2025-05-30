//
//  TextLayerView.swift
//  PeepIt
//
//  Created by 김민 on 1/13/25.
//

import SwiftUI
import ComposableArchitecture

struct TextLayerView: View {
    let store: StoreOf<TextLayerStore>

    var body: some View {
        GeometryReader { geo in
            WithPerceptionTracking {
                ForEach(store.textItems, id: \.id) { textItem in
                    WithPerceptionTracking {
                        let scale = (
                            store.textInDeleteArea.contains(textItem.id) ?
                            textItem.scale * 0.6 : textItem.scale
                        )

                        Text(textItem.text)
                            .opacity(
                                store.selectedTextId == textItem.id ? 0 : 1
                            )
                            .font(.system(size: textItem.fontSize))
                            .scaleEffect(scale)
                            .fontWeight(.bold)
                            .foregroundStyle(textItem.color)
                            .multilineTextAlignment(.center)
                            .fixedSize()
                            .position(textItem.position)
                            /// 텍스트 드래그 제스처
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        store.send(
                                            .textDragged(
                                                id: textItem.id,
                                                loc: gesture.location
                                            )
                                        )
                                    }
                                    .onEnded { _ in
                                        store.send(.textDragEnded(id: textItem.id))
                                    }
                            )
                            /// 스티커 확대/축소 제스처
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { scale in
                                        store.send(.updateTextScale(id: textItem.id, scale: scale))
                                    }
                                    .onEnded { scale in
                                        store.send(.updateTextScaleEnded(id: textItem.id, scale: scale))
                                    }
                            )
                            .onTapGesture {
                                store.send(.textTapped(textItem: textItem))
                            }
                            /// 텍스트  롱탭 제스처
                            .onLongPressGesture(
                                minimumDuration: 1,
                                perform: { },
                                onPressingChanged: { isPressing in
                                    if isPressing {
                                        store.send(.textLongerTapped)
                                    } else {
                                        store.send(.textLongerTapEnded)
                                    }
                                }
                            )
                            .onAppear {
                                if textItem.position == .zero {
                                    let initPosition = CGPoint(
                                        x: geo.size.width / 2,
                                        y: geo.size.height / 2
                                    )

                                    store.send(
                                        .setInitialTextPosition(id: textItem.id, position: initPosition)
                                    )
                                }
                            }
                    }
                }
            }
        }
    }
}


#Preview {
    TextLayerView(
        store: Store(initialState: TextLayerStore.State()) {
            TextLayerStore()
        }
    )
}
