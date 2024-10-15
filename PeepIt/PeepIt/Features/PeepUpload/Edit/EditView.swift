//
//  EditView.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import SwiftUI
import ComposableArchitecture

struct EditView: View {
    @Perception.Bindable var store: StoreOf<EditStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 25) {
                    Spacer()

                    soundButton
                    stickerButton
                    textButton

                    Spacer()

                    uploadButton
                }
                .padding(.horizontal, 17)

                ForEach(store.stickers, id: \.id) { sticker in
                    DraggableSticker(sticker: sticker, store: store)
                }
            }
            .sheet(
                item: $store.scope(
                    state: \.stickerModalState,
                    action: \.stickerListAction
                )
            ) { store in
                StickerModalView(store: store)
                    .presentationDetents([.height(600)])
            }
        }
    }

    private var soundButton: some View {
        HStack {
            Button {
                store.send(.soundOnOffButtonTapped)
            } label: {
                Text("소리 on/off")
            }
            Spacer()
        }
    }

    private var stickerButton: some View {
        HStack {
            Button {
                store.send(.stickerButtonTapped)
            } label: {
                Text("스티커")
            }
            Spacer()
        }
    }

    private var textButton: some View {
        HStack {
            Button {
                store.send(.textButtonTapped)
            } label: {
                Text("텍스트")
            }
            Spacer()
        }
    }

    private var uploadButton: some View {
        HStack {
            Spacer()
            Button {
                store.send(.uploadButtonTapped)
            } label: {
                Text("게시")
            }
        }
    }
}

#Preview {
    EditView(
        store: .init(initialState: EditStore.State()) { EditStore() }
    )
}
