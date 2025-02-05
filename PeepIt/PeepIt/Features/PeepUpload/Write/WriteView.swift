//
//  WriteView.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import SwiftUI
import ComposableArchitecture
import AVKit

struct WriteView: View {
    @Perception.Bindable var store: StoreOf<WriteStore>

    @FocusState private var isFocused: Bool

    @State private var textHeight: CGFloat = 50
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { _ in
                WithPerceptionTracking {
                    ZStack(alignment: .top) {
                        Color.base
                            .ignoresSafeArea()

                        /// 뒤쪽 이미지
                        backImageView
                            .padding(.top, 44)
                            .padding(.top, 11)

                        /// 필터
                        Group {
                            BackImageLayer.primary()
                            BackImageLayer.secondary()
                            Color.blur1
                        }
                        .ignoresSafeArea()

                        VStack(spacing: 0) {
                            peepItNavigationBar
                                .padding(.horizontal, 16)
                                .padding(.bottom, 23)

                            frontImageView
                                .padding(.bottom, 22)

                            bodyTextView
                                .padding(.bottom, 22)

                            uploadButton

                            Spacer()
                        }

                        /// 본문 작성 뷰
                        if store.isBodyInputMode {
                            Color.blur2

                            VStack {
                                HStack {
                                    Spacer()
                                    doneButton
                                }
                                .padding(.horizontal, 16)

                                textEditor
                            }
                        }
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                    .toolbar(.hidden, for: .navigationBar)
                    .animation(.easeInOut(duration: 0.3), value: keyboardHeight)
                    .overlay {
                        WriteMapModalView(store: self.store)
                            .offset(y: store.modalOffset)
                            .animation(.easeInOut(duration: 0.3), value: store.modalOffset)
                    }
                    .onTapGesture { store.send(.viewTapped) }
                    .modifier(KeyboardHeightDetector($keyboardHeight))
                }
            }
        }
    }

    private var peepItNavigationBar: some View {
        ZStack {
            HStack {
                Spacer()

                DismissButton { store.send(.dismissButtonTapped) }
            }

            TownTitleView(townName: "동이름")
                .onTapGesture { store.send(.addressTapped) }
        }
        .frame(height: 44)
        .opacity(store.isBodyInputMode ? 0 : 1)
    }

    private var backImageView: some View {
        Group {
            if let image = store.image {
                Image(uiImage: image)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            } else if let url = store.videoURL {
                videoThumbnail(from: url)
            } else {
                Rectangle()
            }
        }
        .aspectRatio(9 / 16, contentMode: .fit)
        .frame(width: Constant.screenWidth)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var frontImageView: some View {
        Group {
            if let image = store.image {
                Image(uiImage: image)
                    .resizable()
            } else if let url = store.videoURL {
                videoThumbnail(from: url)
            } else {
                Rectangle()
            }
        }
        .scaledToFill()
        .frame(width: 300, height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .allowsHitTesting(false)
    }

    private var bodyTextView: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.blur1)

            if store.bodyText.isEmpty {
                Text("무슨 일이 일어나고 있나요?")
                    .foregroundStyle(Color.nonOp)
                    .padding(.all, 18)
            }

            ScrollView {
                Text(store.bodyText)
                    .foregroundStyle(Color.white)
                    .padding(.all, 18)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .scrollIndicators(.hidden)
            .clipped()
        }
        .pretendard(.body04)
        .frame(width: 300, height: 142)
        .onTapGesture {
            store.send(.bodyTextEditorTapped)
            isFocused = true
        }
    }

    private var uploadButton: some View {
        Button {
            store.send(.uploadButtonTapped)
        } label: {
            Text("업로드")
        }
        .mainLimeButtonStyle(width: 300)
    }

    private var textEditor: some View {
        ZStack {
            if store.bodyText.isEmpty {
                Text("Text")
                    .foregroundStyle(Color.nonOp)
            }

            TextEditor(text: $store.bodyText)
                .focused($isFocused)
                .frame(height: textHeight)
                .frame(minHeight: 50, maxHeight: 384)
                .frame(width: Constant.screenWidth)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(Color.white)
                .tint(Color.coreLime)
                .scrollContentBackground(.hidden)
                .multilineTextAlignment(.center)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: store.bodyText) { _ in
                                DispatchQueue.main.async {
                                    adjustTextEditorHeight()
                                }
                            }
                    }
                )
                .frame(
                    height: Constant.screenHeight - 44 - keyboardHeight - Constant.safeAreaTop
                )
                .offset(x: store.bodyText.isEmpty ? -30 : 0)
                .simultaneousGesture(DragGesture().onChanged { _ in }) /// TextEditor 스크롤해도 키보드 닫히지 않도록
        }
        .pretendard(.title01)
    }

    private var doneButton: some View {
        Button {
            endTextEditing()
            store.send(.doneButtonTapped)
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 38, height: 38)
        }
        .buttonStyle(
            PressableButtonStyle(originImg: "DoneN", pressedImg: "DoneY")
        )
    }

    @ViewBuilder
    private func videoThumbnail(from url: URL) -> some View {
        if let url = store.videoURL,
            let thumbnail = generateThumbnail(from: url) {
            Image(uiImage: thumbnail)
                .resizable()
        }
    }
}

extension WriteView {

    /// 본문 작성 크기 조절 위한 메서드
    private func adjustTextEditorHeight() {
        let lineHeight: CGFloat = PeepItFont.title01.lineHeight
        let defaultPadding: CGFloat = 8
        let maxHeight: CGFloat = Constant.screenHeight - 44 - keyboardHeight - Constant.safeAreaTop
        let minHeight: CGFloat = lineHeight + defaultPadding*2

        let font = UIFont(
            name: PeepItFont.title01.style,
            size: PeepItFont.title01.size
        ) ?? UIFont.systemFont(ofSize: 28)

        /// 자동 줄바꿈 계산 위한 로직
        let textSize = (store.bodyText as NSString)
            .boundingRect(
                with: CGSize(
                    width: Constant.screenWidth - defaultPadding,
                    height: .greatestFiniteMagnitude
                ),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            )

        /// 엔터를 쳐서 줄바꿈을 했을 때를 위한 로직
        let lineCount = max(1, store.bodyText.filter { $0 == "\n" }.count + 1)
        let calculatedHeight = max(lineHeight * CGFloat(lineCount), textSize.height) + defaultPadding*2

        let newHeight = min(max(minHeight, calculatedHeight), maxHeight)

        if newHeight != textHeight {
            withAnimation(.easeInOut(duration: 0.05)) {
                textHeight = newHeight
            }
        }
    }

    /// 썸네일 생성
    private func generateThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true

        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Failed to generate thumbnail: \(error)")
            return nil
        }
    }
}

#Preview {
    WriteView(
        store: .init(initialState: WriteStore.State()) { WriteStore() }
    )
}
