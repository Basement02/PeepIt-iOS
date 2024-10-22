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
                ForEach(store.stickers, id: \.id) { sticker in
                    DraggableSticker(sticker: sticker, store: store)
                }

                ForEach(store.texts, id: \.id) { textItem in
                    DraggableText(textItem: textItem, store: store)
                        .opacity(store.selectedText?.id == textItem.id ? 0 : 1)
                        .onTapGesture {
                            store.send(.textFieldTapped(textId: textItem.id))
                        }
                }

                switch store.editMode {
                    
                case .original:
                    VStack(spacing: 25) {
                        Spacer()

                        soundButton
                        stickerButton
                        textButton

                        Spacer()

                        uploadButton
                    }
                    .padding(.horizontal, 17)

                case .textInputMode:
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    VStack {
                        Spacer()

                        HStack {
                            if store.selectedText == nil {
                                TextField("텍스트 입력...", text: $store.inputText)
                                    .font(.system(size: store.inputTextSize))
                                    .foregroundStyle(store.inputTextColor)
                            }

                            Spacer()

                            SliderView(
                                store: store.scope(
                                    state: \.sliderState,
                                    action: \.sliderAction
                                )
                            )
                            .frame(width: 10, height: 250)
                        }

                        Spacer()

                    }
                    .padding(.horizontal, 17)

                    // TODO:  dynamic text field
                    if let _ = store.selectedText {
                        TextField("", text: $store.inputText)
                            .font(.system(size: store.inputTextSize))
                            .foregroundStyle(store.inputTextColor)
                    }

                case .editMode:
                    VStack {
                        Spacer()
                        deleteButton
                    }
                    .padding(.horizontal, 17)
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    colorList
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if store.editMode == .textInputMode {
                        textInputCompleteButton
                    }
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

    private var textInputCompleteButton: some View {
        HStack {
            Spacer()

            Button {
                store.send(.textInputCompleteButtonTapped)
            } label: {
                Text("완료")
            }
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

    private var deleteButton: some View {
        Button {

        } label: {
            Text("삭제")
        }
    }

    private var colorList: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<13) { idx in
                    Button {
                        let randomColor = Color(
                            red: Double.random(in: 0...1),
                            green: Double.random(in: 0...1),
                            blue: Double.random(in: 0...1)
                        )
                        
                        store.send(.textColorTapped(newColor: randomColor))
                    } label: {
                        Text("색\(idx)")
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    EditView(
        store: .init(initialState: EditStore.State()) { EditStore() }
    )
}
