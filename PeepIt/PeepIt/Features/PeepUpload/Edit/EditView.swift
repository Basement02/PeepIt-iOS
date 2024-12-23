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
                Color.white
                    .ignoresSafeArea()

                if let image = store.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }

                Group {
                    BackImageLayer.primary()
                    BackImageLayer.secondary()
                }
                .ignoresSafeArea()

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
                    ZStack {
                        VStack {
                            HStack {
                                if !store.isDoneButtonShowed {
                                    BackButton { store.send(.backButtonTapped) }
                                }

                                Spacer()

                                if store.isDoneButtonShowed {
                                    completeButton
                                }

                            }
                            .padding(.horizontal, 16)

                            Spacer()

                            uploadButton
                                .padding(.bottom, 71.adjustedH)
                                .padding(.trailing, 4)
                        }

                        VStack(spacing: 25) {
                            stickerButton
                            textButton
                        }
                        .padding(.leading, 16)
                    }

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
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(
                item: $store.scope(
                    state: \.stickerModalState,
                    action: \.stickerListAction
                )
            ) { store in
                StickerModalView(store: store)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(675)])
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
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(
                PressableButtonStyle(originImg: "StickerN", pressedImg: "StickerY")
            )
            Spacer()
        }
    }

    private var textButton: some View {
        HStack {
            Button {
                store.send(.textButtonTapped)
            } label: {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 42, height: 42)
            }
            .buttonStyle(
                PressableButtonStyle(originImg: "TextN", pressedImg: "TextY")
            )
            Spacer()
        }
    }

    private var completeButton: some View {
        HStack {
            Spacer()

            Button {

            } label: {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 38, height: 38)
            }
            .buttonStyle(
                PressableButtonStyle(originImg: "DoneN", pressedImg: "DoneY")
            )
        }
    }

    private var uploadButton: some View {
        HStack {
            Spacer()

            Button {
                store.send(.uploadButtonTapped)
            } label: {
                Image("UploadBtnN")
            }
            .buttonStyle(
                PressableButtonStyle(originImg: "UploadBtnN", pressedImg: "UploadBtnY")
            )
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
