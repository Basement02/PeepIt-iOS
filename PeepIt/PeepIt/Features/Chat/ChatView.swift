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
                        VStack(spacing: 11) {
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
                                .padding(.bottom, 33)

                            // FIX: - 여기 더보기했을 때 패딩도 고쳐야 함
                            uploaderBodyView
                                .padding(.bottom, 17)

                            chatListView
                                .padding(.bottom, keyboardHeight)
                                .clipped()

                            enterFieldView
                                .padding(
                                    .bottom, keyboardHeight == 0 ?
                                    34.adjustedH : 18
                                )
                                .offset(y: -keyboardHeight)
                                .animation(.easeInOut, value: keyboardHeight)
                        }
                        .onTapGesture { endTextEditing() }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .onAppear(perform: addKeyboardObserver)
                        .onDisappear(perform: removeKeyboardObserver)
                    }
                    .onAppear {
                        store.send(.onAppear)
                    }
                    .overlay {
                        if store.showChatDetail {
                            chatDetail
                        }
                    }
                }
            }
        }
    }

    private var chatDetail: some View {
        ZStack(alignment: .top) {
            Color.blur1
                .onTapGesture { store.send(.closeChatDetail) }

            if let selectedChat = store.selectedChat {
                VStack {
                    originalChatCell(chat: selectedChat)

                    Spacer()

                    Button {
                        store.send(.reportButtonTapped)
                    } label: {
                        HStack(spacing: 3) {
                            Image("CombiReportBtnN")
                            Text("신고하기")
                                .foregroundStyle(Color.coreRed)
                        }
                        .frame(width: 108)
                        .padding(.vertical, 13)
                        .padding(.leading, 18)
                        .padding(.trailing, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray600)
                        )
                    }
                    .padding(.bottom, 78.12)
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea()
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
                    Text(store.peepBody.message)
                        .pretendard(.body04)
                        .lineLimit(nil)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        if geo.size.height >= 100 {
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
                        Text(store.peepBody.message)
                            .pretendard(.body04)
                            .lineLimit(5)
                            .padding(.horizontal, 14)
                            .padding(.top, 12)
                            .padding(.bottom, store.isBodyTrunscated ? 36 : 12)
                            .background(
                                VStack(spacing: 0) {
                                    ZStack(alignment: .bottomTrailing) {
                                        Rectangle()
                                            .fill(Color.coreLimeDOp)
                                            .roundedCorner(13.2, corners: .topRight)
                                            .makeCorner(of: .uploader)

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
        .gesture(
            LongPressGesture(minimumDuration: 1.2)
                .onEnded { isPressed in
                    if isPressed {
                        store.send(.chatLongTapped(chat: store.peepBody))
                    }
                }
        )
    }

    private var enterFieldView: some View {
        HStack(alignment: .bottom) {
            TextEditor(text: $store.message)
                .pretendard(.body04)
                .foregroundStyle(Color.white)
                .tint(Color.coreLime)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 20, maxHeight: 110)
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

    private var chatListView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(store.chats, id: \.id) { chat in
                    chatCell(chat: chat) {
                        store.send(.showMoreButtonTapped(chat: chat))
                    }
//                        .gesture(
//                            DragGesture()
//                                .onChanged { _ in /* 스크롤 중 */ }
//                                .simultaneously(with: LongPressGesture(minimumDuration: 1.2)
//                                    .onEnded { isPressed in
//                                        if isPressed {
//                                            store.send(.chatLongTapped(chat: chat))
//                                        }
//                                    }
//                                )
//                        )
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func chatCell(
        chat: Chat,
        action: @escaping () -> Void
    ) -> some View {
        switch chat.type {

        case .mine:
            HStack {
                Spacer()
                ChatBubbleView(chat: chat, showMoreButtonTapped: action)
            }

        case .uploader, .others:
            HStack(alignment: .top, spacing: 10) {
                Image("ProfileSample")
                    .resizable()
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 7) {
                        Text(chat.user.nickname)
                            .pretendard(.caption03)
                        Text(chat.sendTime)
                            .pretendard(.caption04)
                    }

                    ChatBubbleView(chat: chat, showMoreButtonTapped: action)
                }

                Spacer()
            }
        }
    }

    @ViewBuilder
    private func originalChatCell(chat: Chat) -> some View {
        switch chat.type {

        case .mine:
            OriginalChatBubbleView(chat: chat)
                .padding(.top, 169)

        case .uploader, .others:
            OtherOriginalChatBubbleView(chat: chat)
                .padding(.top, 136)
        }
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

import UIKit

struct LongPressGestureModifier: UIViewRepresentable {
    var action: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        longPress.minimumPressDuration = 1.2
        view.addGestureRecognizer(longPress)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    class Coordinator: NSObject {
        var action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc func handleLongPress() {
            action()
        }
    }
}
