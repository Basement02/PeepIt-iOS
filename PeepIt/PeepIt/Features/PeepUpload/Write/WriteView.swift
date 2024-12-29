//
//  WriteView.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import SwiftUI
import ComposableArchitecture

struct WriteView: View {
    @Perception.Bindable var store: StoreOf<WriteStore>

    init(store: StoreOf<WriteStore>) {
        self.store = store

        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                if let image = store.image {
                    Image(uiImage: image)
//                        .mask(
//                            RoundedRectangle(cornerRadius: 24)
//                                .aspectRatio(9 / 16, contentMode: .fit)
//                                .frame(width: Constant.screenWidth)
//                        )
                } else {
                    Rectangle()
                        .aspectRatio(9 / 16, contentMode: .fit)
                        .frame(width: Constant.screenWidth)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var placeButton: some View {
        Button {

        } label: {
            Text("장소 표시")
        }
    }

    private var textView: some View {
        VStack(spacing: 11) {
            HStack {
                Text("무슨 일이 일어나고 있나요?")
                    .font(.system(size: 12))
                Spacer()
            }

            TextEditor(text: $store.textView)
                .frame(height: 220)
                .background(Color.black)
        }
    }

    private var uploadButton: some View {
        Button {
            store.send(.uploadButtonTapped)
        } label: {
            Text("업로드")
        }
    }
}

#Preview {
    WriteView(
        store: .init(initialState: WriteStore.State()) { WriteStore() }
    )
}
