//
//  EditView.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import SwiftUI
import AVKit
import ComposableArchitecture

struct EditView: View {
    @Perception.Bindable var store: StoreOf<EditStore>

    @FocusState var isFocused: Bool

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .top) {
                Color.base
                    .ignoresSafeArea()

                /// 보여주는 이미지에는 corner radius 처리
                peepView
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.top, 44)
                    .padding(.top, 11.adjustedH)

                /// 편집 모드(기본, 텍스트 추가/편집, 드래그/줌)에 따른 UI 구성
                switch store.editMode {

                /// 기본
                case .original:
                    ZStack {
                        VStack(spacing: 0) {
                            HStack {
                                BackButton { store.send(.backButtonTapped) }

                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.horizontal, 16)

                            Spacer()
                        }

                        HStack {
                            VStack(spacing: 25) {
                                if let _ = store.videoURL { soundButton }
                                stickerButton
                                textButton
                            }
                            .fixedSize()

                            Spacer()
                        }
                        .padding(.leading, 16)

                        VStack {
                            Spacer()

                            HStack {
                                Spacer()
                                uploadButton
                                    .padding(.bottom, 61.adjustedH)
                                    .padding(.trailing, 4)
                            }
                        }
                    }

                /// 텍스트 입력창 (추가 및 편집)
                case .textInputMode:
                    BackMapPointer.secondary
                        .ignoresSafeArea()

                    VStack {
                        textInputTopBar
                            .padding(.horizontal, 16)

                        Spacer()
                    }

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
            .onDisappear {
                store.send(.onDisappear)
            }
        }
    }

    /// 이미지(영상) + 스티커 + 텍스트 -> 최종 저장할 핍
    private var peepView: some View {
        ZStack {
            if let image = store.image {
                Image(uiImage: image)
                    .resizable()
            } else if let url = store.videoURL {
                LoopingVideoPlayerView(
                    videoURL: url,
                    isSoundOn: store.isVideoSoundOn
                )
            } else {
                Rectangle()
            }

            Group {
                BackImageLayer.primary()
                BackImageLayer.secondary()
            }
            .ignoresSafeArea()
            .opacity(store.isCapturing ? 0 : 1)

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
        }
        .aspectRatio(9/16, contentMode: .fit)
        .frame(width: Constant.screenWidth)
        .clipShape(Rectangle())
    }

    private var colorChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 3) {
                ForEach(ChipColors.allCases, id: \.self) { chip in
                    ColorChip(color: chip.color)
                        .onTapGesture {
                            store.send(.textColorTapped(newColor: chip.color))
                        }
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
                .frame(width: Constant.screenWidth)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: store.inputTextSize, weight: .bold))
                .foregroundStyle(store.inputTextColor)
                .tint(Color.coreLime)
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
                .multilineTextAlignment(.center)
                .onAppear {
                    isFocused = true
                }

            Spacer()
        }
    }

    private var soundButton: some View {
        Button {
            store.send(.soundOnOffButtonTapped)
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 42, height: 42)
        }
        .buttonStyle(
            store.isVideoSoundOn ?
            PressableButtonStyle(originImg: "SoundOnN", pressedImg: "SoundOnY") :
                PressableButtonStyle(originImg: "SoundOffN", pressedImg: "SoundOffY")
        )
    }

    private var stickerButton: some View {
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
    }

    private var textButton: some View {
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

                let renderer = ImageRenderer(content: peepView)
                renderer.scale = UIScreen.main.scale 

                if let uiimage = renderer.uiImage, let _ = store.image {
                    store.send(.pushToWriteBody(image: uiimage, videoURL: nil))
                } else if let url = store.videoURL {
                    store.send(.renderVideo(url: url))
                }
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
}

#Preview {
    EditView(
        store: .init(initialState: EditStore.State()) { EditStore() }
    )
}
