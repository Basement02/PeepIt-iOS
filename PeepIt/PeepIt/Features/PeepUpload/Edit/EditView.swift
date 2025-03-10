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
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { geo in
                WithPerceptionTracking {
                    ZStack(alignment: .top) {
                        Color.base
                            .ignoresSafeArea()

                        /// 보여주는 이미지에는 corner radius 처리
                        VStack {
                            peepView
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .padding(.top, 44)
                                .padding(.top, 11)
                            Spacer()
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)

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
                                        if store.dataType == .video { soundButton }
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
                                            .padding(.bottom, 60.88)
                                            .padding(.trailing, 7.75)
                                    }
                                }
                                .ignoresSafeArea(.all, edges: .bottom)
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
                            .frame(height: Constant.screenHeight)

                            textEditor
                                .padding(.top, 44)
                                .padding(.top, 22)

                            /// 오브젝트(스티커, 텍스트) 드래그 및 삭제
                        case .editMode:
                            VStack {
                                Spacer()

                                deleteButton
                                    .padding(.bottom, 84)
                            }
                            .ignoresSafeArea(.all, edges: .bottom)
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
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
                    .modifier(KeyboardHeightDetector($keyboardHeight))
                    .onAppear { store.send(.onAppear) }
                    .onDisappear { store.send(.onDisappear) }
                }
            }
        }
    }

    /// 이미지(영상) + 스티커 + 텍스트 -> 최종 저장할 핍
    private var peepView: some View {
        ZStack {
            switch store.dataType {
            case .image:
                if let image = store.image {
                    Image(uiImage: image)
                        .resizable()
                }
            case .video:
                if let url = store.videoURL {
                    LoopingVideoPlayerView(
                        videoURL: url,
                        isSoundOn: store.isVideoSoundOn,
                        isPlaying: store.isVideoPlaying
                    )
                }
            }

            Group {
                BackImageLayer.primary()
                BackImageLayer.secondary()
            }
            .ignoresSafeArea()
            .opacity(store.isCapturing ? 0 : 1)

            StickerLayerView(
                store: store.scope(
                    state: \.stickerState, action: \.stickerAction
                )
            )

            TextLayerView(
                store: store.scope(
                    state: \.textState, action: \.textAction
                )
            )
        }
        .frame(width: Constant.screenWidth, height: Constant.screenWidth * 16/9)
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
        ZStack {
            if store.inputText.isEmpty {
                Text("Text")
                    .pretendard(.title01)
                    .foregroundStyle(Color.nonOp)
            }

            TextEditor(text: $store.inputText)
                .focused($isFocused)
                .frame(height: store.currentTextSize.height)
                .frame(minHeight: 34)
                .frame(
                    maxHeight: Constant.screenHeight - 44 - keyboardHeight - Constant.safeAreaTop - 22
                )
                .frame(width: Constant.screenWidth)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: store.currentTextItem?.fontSize ?? 28, weight: .bold))
                .foregroundStyle(store.currentTextItem?.color ?? .white)
                .tint(Color.coreLime)
                .scrollContentBackground(.hidden)
                .multilineTextAlignment(.center)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: store.inputText) { _ in
                                DispatchQueue.main.async {
                                    adjustTextEditorHeight()
                                }
                            }
                            .onChange(of: store.currentTextItem?.fontSize) { _ in
                                DispatchQueue.main.async {
                                    adjustTextEditorHeight()
                                }
                            }
                    }
                )
                .onAppear { isFocused = true }
                .offset(x: store.inputText.isEmpty ? -30 : 0)
                .simultaneousGesture(DragGesture().onChanged { _ in }) /// TextEditor 스크롤해도 키보드 닫히지 않도록

            HStack {
                fontSlider
                    .fixedSize()
                Spacer()
            }
            .padding(.leading, 12)
        }
        .frame(
            height: Constant.screenHeight - 44 - keyboardHeight - Constant.safeAreaTop - 22
        )
    }

    private var soundButton: some View {
        Button {
            store.send(.soundOnOffButtonTapped)
        } label: {
            Image(store.isVideoSoundOn ? "SoundOn" : "SoundOff")
        }
        .frame(width: 42, height: 42)
    }

    private var stickerButton: some View {
        Button {
            store.send(.stickerButtonTapped)
        } label: {
            Image("StickerN")
                .resizable()
                .frame(width: 42, height: 42)
        }
    }

    private var textButton: some View {
        Button {
            store.send(.textButtonTapped)
            isFocused = true
        } label: {
            Image("TextN")
                .resizable()
                .frame(width: 42, height: 42)
        }
    }

    private var completeButton: some View {
        HStack {
            Spacer()

            Button {
                isFocused = false
                store.send(.textInputCompleteButtonTapped)
            } label: {
                Image("DoneN")
                    .resizable()
                    .frame(width: 38, height: 38)
            }
        }
    }

    private var uploadButton: some View {
        let normal = Image("UploadBtnN")
            .resizable()
            .frame(width: 94, height: 95)
        let pressable = Image("UploadBtnY")
            .resizable()
            .frame(width: 94, height: 95)

        return HStack {
            Spacer()

            Button {
                switch store.dataType {

                case .image:
                    store.send(.uploadButtonTapped)

                    let renderer = ImageRenderer(content: peepView)
                    renderer.scale = UIScreen.main.scale

                    if let uiimage = renderer.uiImage {
                        store.send(.pushToWriteBody(image: uiimage, videoURL: nil))
                    }

                case .video:
                    if let _ = store.videoURL {
                        store.send(.renderVideo)
                    }
                }
            } label: {
                Image("UploadBtnN")
                    .resizable()
                    .frame(width: 94, height: 95)
                    .hidden()
            }
            .buttonStyle(
                PressableViewButtonStyle(
                    normalView: normal,
                    pressedView: pressable
                )
            )
        }
    }

    private var deleteButton: some View {
        Button {

        } label: {
            Image("TrashcanN")
                .resizable()
                .frame(width: 42, height: 42)
                .scaleEffect(
                    store.stickerState.isDeleteAreaActive ||
                    store.textState.isDeleteAreaActive
                    ? 1.25 : 1.0
                )
        }
        .background(
            GeometryReader { geo in
                WithPerceptionTracking {
                    Color.clear
                        .onAppear {
                            var deleteFrame = geo.frame(in: .global)
                            /// 좌표계 맞추기 위한 계산(삭제 버튼은 전체 좌표, 스티커는 PeepView 좌표)
                            deleteFrame.origin.y -= (safeAreaTopInset() + CGFloat(44) + 11)
                            store.send(.setDeleteFrame(rect: deleteFrame))
                        }
                }
            }
        )
    }
}

extension EditView {

    /// 본문 작성 크기 조절 위한 메서드
    private func adjustTextEditorHeight() {
        // 키보드가 올라와 있을 때만 실행함
        guard isFocused else { return }

        let font = UIFont.systemFont(
            ofSize: store.currentTextItem?.fontSize ?? 24,
            weight: .bold
        )
        let maxHeight = CGFloat(
            Constant.screenHeight - 44
            - keyboardHeight
            - Constant.safeAreaTop - 22
        )
        let minHeight = font.lineHeight

        /// 자동 줄바꿈 계산 위한 로직
        let textSize = (store.inputText as NSString)
            .boundingRect(
                with: CGSize(
                    width: Constant.screenWidth-8,
                    height: .greatestFiniteMagnitude
                ),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            )

        let lineCount = max(1, store.inputText.filter { $0 == "\n" }.count + 1)
        let calculatedHeight = max(font.lineHeight * CGFloat(lineCount), textSize.height) + 18

        let newHeight = min(max(minHeight, calculatedHeight), maxHeight)

        if newHeight != store.currentTextSize.height {
            store.send(.setTextSize(size: .init(
                width: textSize.width,
                height: newHeight))
            )
        }
    }
}

#Preview {
    EditView(
        store: .init(initialState: EditStore.State()) { EditStore() }
    )
}
