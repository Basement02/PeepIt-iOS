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
                VStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: 10)
                        .aspectRatio(3/4, contentMode: .fit)
                        .padding(.horizontal, 68) // TODO: 수정
                        .foregroundStyle(Color.gray)

                    Spacer()

                    textView

                    uploadButton
                }
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    placeButton
                }
            }
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
