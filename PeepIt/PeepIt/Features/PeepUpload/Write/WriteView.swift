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

    @FocusState var isFocused: Bool

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { _ in
                WithPerceptionTracking {
                    ZStack(alignment: .top) {
                        Color.base
                            .ignoresSafeArea()

                        backImageView
                            .padding(.top, 44)
                            .padding(.top, 11.adjustedH)

                        Group {
                            BackImageLayer.primary()
                            BackImageLayer.secondary()
                            Color.blur1
                        }
                        .ignoresSafeArea()

                        VStack(spacing: 0) {
                            peepItNavigationBar
                                .padding(.horizontal, 16)
                                .padding(.bottom, 23.adjustedH)

                            frontImageView
                                .padding(.bottom, 22.adjustedH)

                            bodyTextView
                                .padding(.bottom, 22.adjustedH)

                            uploadButton

                            Spacer()
                        }

                        if store.isBodyInputMode {
                            Color.blur2

                            VStack {
                                HStack {
                                    Spacer()
                                    doneButton
                                }
                                .padding(.horizontal, 16)

                                textEditor
                                    .padding(.top, 168.adjustedH)

                                Spacer()
                            }
                        }
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                    .toolbar(.hidden, for: .navigationBar)
                    .onTapGesture {
                        endTextEditing()
                    }
                }
            }
        }
    }

    private var textEditor: some View {
        TextEditor(text: $store.bodyText)
            .focused($isFocused)
            .frame(minHeight: 34)
            .frame(width: Constant.screenWidth)
            .fixedSize(horizontal: false, vertical: true)
            .pretendard(.title02)
            .foregroundStyle(Color.nonOp)
            .tint(Color.coreLime)
            .scrollDisabled(false)
            .scrollContentBackground(.hidden)
            .multilineTextAlignment(.center)
            .onAppear { isFocused = true }
    }

    private var peepItNavigationBar: some View {
        ZStack {
            TownTitleView(townName: "동이름")

            HStack {
                Spacer()

                DismissButton { store.send(.dismissButtonTapped) }
            }
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
                LoopingVideoPlayerView(
                    videoURL: url,
                    isSoundOn: true,
                    isPlaying: true
                )
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
                    .scaledToFill()
            } else {
                Rectangle()
            }
        }
        .frame(width: 300, height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var bodyTextView: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.blur1)

            ScrollView {
                Text(store.bodyText.isEmpty ? "무슨 일이 일어나고 있나요?" : store.bodyText)
                    .pretendard(.body04)
                    .foregroundStyle(Color.nonOp)
                    .padding(.all, 18)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .frame(width: 300, height: 142)
        .onTapGesture {
            store.send(.bodyTextEditorTapped)
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
}

#Preview {
    WriteView(
        store: .init(initialState: WriteStore.State()) { WriteStore() }
    )
}
