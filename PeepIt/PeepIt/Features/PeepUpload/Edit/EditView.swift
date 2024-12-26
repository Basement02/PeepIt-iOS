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

    @FocusState var isFocused: Bool

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                /// 이미지
                if let image = store.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(
                            RoundedRectangle(cornerRadius: 24)
                        )
                }

                Group {
                    BackImageLayer.primary()
                    BackImageLayer.secondary()
                }
                .ignoresSafeArea()

                /// 스티커들
                ForEach(store.stickers, id: \.id) { sticker in
                    DraggableSticker(sticker: sticker, store: store)
                }

                /// 텍스트들
                ForEach(store.texts, id: \.id) { textItem in
                    DraggableText(textItem: textItem, store: store)
                        .opacity(store.selectedText?.id == textItem.id ? 0 : 1)
                        .onTapGesture {
                            store.send(.textFieldTapped(textId: textItem.id))
                        }
                }

                switch store.editMode {

                /// 기본
                case .original:
                    ZStack {
                        VStack {
                            HStack {
                                if !store.isDoneButtonShowed {
                                    BackButton { store.send(.backButtonTapped) }
                                }

                                Spacer()
                            }
                            .padding(.horizontal, 16)

                            Spacer()

                            uploadButton
                                .padding(.bottom, 61.adjustedH)
                                .padding(.trailing, 4)
                        }

                        VStack(spacing: 25) {
                            stickerButton
                            textButton
                        }
                        .padding(.leading, 16)
                    }

                /// 텍스트 입력창 (추가 및 편집)
                case .textInputMode:
                    BackMapPointer.secondary
                        .ignoresSafeArea()

                    textInputTopBar
                        .padding(.horizontal, 16)

                    fontSlider
                        .padding(.top, 175.adjustedH)
                        .padding(.leading, 12)

                    textEditor
                     .padding(.top, 281.adjustedH)

                /// 오브젝트(스티커, 텍스트) 드래그 및 삭제
                case .editMode:
                    VStack {
                        Spacer()
                        deleteButton
                            .padding(.bottom, 84.adjustedH)
                    }
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
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    colorChips
                        .frame(width: Constant.screenWidth)
                        .background(Color.clear)
                        .padding(.leading, 9)
                        .padding(.bottom, 8)
                }
            }
            .background(KeyboardToolbarView())
        }
    }

    private var colorChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 3) {
                ForEach(0..<10) { _ in
                    ColorChip(color: .coreLime)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var textInputTopBar: some View {
        VStack {
            HStack {
                Spacer()
                completeButton
            }

            Spacer()
        }
    }

    private var fontSlider: some View {
        VStack {
            HStack {
                SliderView(
                    store: store.scope(
                        state: \.sliderState,
                        action: \.sliderAction
                    )
                )
                Spacer()
            }

            Spacer()
        }
    }

    private var textEditor: some View {
        VStack {
            TextEditor(text: $store.inputText)
                .focused($isFocused)
                .frame(minHeight: 34)
                .fixedSize(horizontal: false, vertical: true)
                .scrollContentBackground(.hidden)
                .multilineTextAlignment(.center)
                .scrollDisabled(true)
                .tint(Color.coreLime)
                .font(.system(size: store.inputTextSize, weight: .bold))
                .onAppear {
                    isFocused = true
                }

            Spacer()
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
                isFocused = true
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
                store.send(.textInputCompleteButtonTapped)
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
            Rectangle()
                .fill(Color.clear)
                .frame(width: 42, height: 42)
        }
        .buttonStyle(
            PressableButtonStyle(originImg: "TrashcanN", pressedImg: "TrashcanY")
        )
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
