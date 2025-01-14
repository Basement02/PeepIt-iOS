//
//  ChatView.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {
    @Perception.Bindable var store: StoreOf<ChatStore>

    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { geo in
                WithPerceptionTracking {
                    ZStack {
                        Color.base.ignoresSafeArea()

                        /// 배경 핍 이미지
                        VStack(spacing: 11.adjustedH) {
                            topBar
                                .opacity(0)

                            /// TODO: 이미지
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                                .aspectRatio(9/16, contentMode: .fit)
                                .frame(width: Constant.screenWidth)

                            Spacer()
                        }
                        .ignoresSafeArea(.all, edges: .bottom)

                        /// 필터 레이어
                        Group {
                            BackImageLayer.primary()
                            BackImageLayer.secondary()
                            Color.blur1
                        }
                        .ignoresSafeArea()

                        /// 채팅 UI
                        VStack(spacing: 0) {
                            topBar
                                .padding(.bottom, 33.adjustedH)

                            uploaderBodyView

                            Spacer()

                            enterFieldView
                                .padding(
                                    .bottom, keyboardHeight == 0 ?
                                    34.adjustedH : 18
                                )
                                .offset(y: -keyboardHeight)
                                .animation(.easeInOut, value: keyboardHeight)
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .onAppear(perform: addKeyboardObserver)
                        .onDisappear(perform: removeKeyboardObserver)
                    }
                }
            }
        }
    }

    private var topBar: some View {
        ZStack {
            TownTitleView(townName: "동이름")

            HStack {
                Spacer()

                DismissButton {
                    store.send(.closeChatButtonTapped)
                }
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 17)
    }

    private var uploaderBodyView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image("ProfileSample")
                .resizable()
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 7) {
                    Text("닉네임")
                        .pretendard(.caption03)
                    Text("0분 전")
                        .pretendard(.caption04)
                }

                ZStack(alignment: .topTrailing) {
                    /// 채팅 높이 계산 위한 뷰
                    Text(store.peepBody)
                        .pretendard(.body04)
                        .lineLimit(nil)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        if geo.size.height >= 100 {
                                            print(geo.size)
                                            store.send(.setBodyIsTrunscated)
                                        }
                                    }
                            }
                        )
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .opacity(0)

                    VStack(spacing: 0) {
                        /// 진짜 채팅 뷰
                        Text(store.peepBody)
                            .pretendard(.body04)
                            .lineLimit(5)
                            .padding(.horizontal, 14)
                            .padding(.top, 12)
                            .padding(.bottom, store.isBodyTrunscated ? 36 : 12)
                            .background(
                                VStack(spacing: 0) {
                                    ZStack(alignment: .bottomTrailing) {
                                        Rectangle()
                                            .fill(Color(hex: 0x6B8400, alpha: 0.5))
                                            .roundedCorner(13.2, corners: .topRight)
                                            .roundedCorner(
                                                store.isBodyTrunscated ? 0 : 13.2,
                                                corners: .bottomRight
                                            )
                                            .roundedCorner(
                                                store.isBodyTrunscated ? 0: 17.6,
                                                corners: .bottomLeft
                                            )

                                        if store.isBodyTrunscated {
                                            Text("더보기")
                                                .pretendard(.caption02)
                                                .foregroundStyle(Color.nonOp)
                                                .padding(.bottom, 12)
                                                .padding(.trailing, 14)
                                        }
                                    }
                                }
                            )
                    }

                    Image("IconBookmark")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .offset(x: 25)
                }
                .frame(maxWidth: 225 + 14 * 2, alignment: .leading)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private var enterFieldView: some View {
        HStack(alignment: .bottom) {
            TextEditor(text: $store.message)
                .pretendard(.body04)
                .foregroundStyle(Color.white)
                .tint(Color.coreLime)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 23, maxHeight: 100)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray700)
                )

            Spacer()
            sendButton
        }
        .padding(.horizontal, 16)
    }


    private var sendButton: some View {
        Button {
            store.send(.sendButtonTapped)
        } label: {
            Image("BoxBtnY")
                .opacity(0)
        }
        .buttonStyle(
            PressableButtonStyle(
                originImg: "BoxBtnY",
                pressedImg: "BoxBtnN"
            )
        )
    }
}

extension ChatView {

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
            keyboardHeight = keyboardFrame.height
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            keyboardHeight = 0
        }
    }

    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview {
    ChatView(
        store: .init(initialState: ChatStore.State()) { ChatStore() }
    )
}
