//
//  ObjectLayerView.swift
//  PeepIt
//
//  Created by 김민 on 1/10/25.
//

import SwiftUI
import ComposableArchitecture

struct StickerLayerView: View {
    let store: StoreOf<StickerLayerStore>
    
    var body: some View {
        GeometryReader { geo in
            WithPerceptionTracking {
                ForEach(store.stickers, id: \.id) { sticker in
                    WithPerceptionTracking {
                        let scale = (
                            store.stickersInDeleteArea.contains(sticker.id) ?
                            sticker.scale * 1.25 : sticker.scale
                        )
                        
                        Image(sticker.stickerName)
                            .resizable()
                            .frame(
                                width: 120 * scale,
                                height: 120 * scale
                            )
                            .position(sticker.position)
                        /// 스티커 드래그 제스처
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        store.send(
                                            .stickerDragged(
                                                id: sticker.id,
                                                loc: gesture.location
                                            )
                                        )
                                    }
                                    .onEnded { _ in
                                        store.send(.stickerDragEnded(id: sticker.id))
                                    }
                            )
                        /// 스티커 롱탭 제스처
                            .onLongPressGesture(
                                minimumDuration: 1,
                                perform: { },
                                onPressingChanged: { isPressing in
                                    if isPressing {
                                        store.send(.stickerLongTapped)
                                    } else {
                                        store.send(.stickerLongTapEnded)
                                    }
                                }
                            )
                        /// 스티커 확대/축소 제스처
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { scale in
                                        store.send(
                                            .updateStickerScale(id: sticker.id, scale: scale)
                                        )
                                    }
                                    .onEnded { _ in
                                        store.send(.scaleUpdateEnded)
                                    }
                            )
                        /// 스티커 처음 등장 시 정중앙으로 세팅
                            .onAppear {
                                if sticker.position == .zero {
                                    let initPosition: CGPoint = .init(
                                        x: geo.size.width / 2,
                                        y: 231.adjustedH + CGFloat(60)
                                    )
                                    
                                    store.send(
                                        .setInitialStickerPosition(
                                            id: sticker.id,
                                            position: initPosition
                                        )
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
    StickerLayerView(
        store: Store(initialState: StickerLayerStore.State()) {
            StickerLayerStore()
        }
    )
}
