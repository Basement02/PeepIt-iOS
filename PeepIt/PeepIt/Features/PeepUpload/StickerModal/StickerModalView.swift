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
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 13) {
                        ForEach(store.stickers, id: \.self) { stckr in
                            Image(stckr.rawValue)
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    store.send(.stickerSelected(selectedSticker: stckr))
                                }
                        }
                    }
                    .padding(.vertical, 58)
                }
            }
        }
    }
}

#Preview {
    StickerModalView(
        store: .init(initialState: StickerModalStore.State()) { StickerModalStore() }
    )
}
