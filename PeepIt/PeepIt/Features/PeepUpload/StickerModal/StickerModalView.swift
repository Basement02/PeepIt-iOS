//
//  StickerModalView.swift
//  PeepIt
//
//  Created by 김민 on 10/14/24.
//

import SwiftUI
import ComposableArchitecture

struct StickerModalView: View {
    let store: StoreOf<StickerModalStore>

    let columns = [
        GridItem(.fixed(80), spacing: 36),
        GridItem(.fixed(80), spacing: 36),
        GridItem(.fixed(80)),
    ]

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                BackdropBlurView(bgColor: .base.opacity(0.9), radius: 1)
                    .ignoresSafeArea()

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 25) {
                        ForEach(0..<50) { _ in
                            Image("😄")
                                .frame(width: 80, height: 80)
                                .onTapGesture {
                                    // TODO: 이모티콘 수정
                                    store.send(.stickerSelected(selectedSticker: "😄"))
                                }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 70)
            }
        }
    }
}

#Preview {
    StickerModalView(
        store: .init(initialState: StickerModalStore.State()) { StickerModalStore() }
    )
}
