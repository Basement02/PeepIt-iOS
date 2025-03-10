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

    @State private var keyboardHeight: CGFloat = .zero
    @State private var sendButtonWidth: CGFloat = .zero
    @State private var enterFieldHorizontalInset: CGFloat = 14
    @State private var enterViewPadding: CGFloat = 16

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
                            Image("SampleImage")
                                .resizable()
                                .aspectRatio(9/16, contentMode: .fit)
                                .frame(width: Constant.screenWidth)
                                .clipShape(RoundedRectangle(cornerRadius: 24))

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

                            uploaderBodyView
                                .padding(.horizontal, 16)
                                .padding(.bottom, 14)

                            chatList
                                .padding(.bottom, keyboardHeight == 0 ? 21 : 0)

                            Rectangle()
                                .frame(
                                    height: keyboardHeight > 0 ?
                                    keyboardHeight + 18 : Constant.safeAreaBottom + 44
                                )
                                .hidden()
                        }
                        .ignoresSafeArea(.all, edges: .bottom)

                        VStack {
                            Spacer()

                            enterFieldView
                                .padding(.bottom,
                                         keyboardHeight > 0 ?
                                         keyboardHeight + 18 : Constant.safeAreaBottom
                                )
                        }
                        .ignoresSafeArea()
                    }
                    .animation(.linear(duration: 0.1), value: keyboardHeight)
                    .ignoresSafeArea(.keyboard)
                    .onTapGesture { endTextEditing() }
                    .onAppear(perform: addKeyboardObserver)
                    .onDisappear(perform: removeKeyboardObserver)
                    .onAppear { store.send(.onAppear) }
                    /// 채팅 상세
                    .overlay {
                        if store.showChatDetail {
                            chatDetail
                        }
                    }
                    /// 채팅 신고
                    .overlay(alignment: .bottom) {
                        if store.showReportModal {
                            Color.op.ignoresSafeArea()
                                .onTapGesture { store.send(.closeReportModal) }
                        }

                        ReportModal(
                            store: store.scope(
                                state: \.report,
                                action: \.report
                            )
                        )
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                        .offset(y: store.reportModalOffset)
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: store.showReportModal
                        )
                    }
                }
            }
        }
    }

    private var chatDetail: some View {
        ZStack(alignment: .top) {
            BackdropBlurView(bgColor: .blur1, radius: 5)
                .onTapGesture { store.send(.closeChatDetail) }

            if let selectedChat = store.selectedChat {
                VStack {
                    originalBubbleView(chat: selectedChat)
                        .padding(.top, 136)

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
                    .padding(.bottom, 78)
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
                    endTextEditing()
                    store.send(.closeChatButtonTapped)
                }
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 17)
    }

    private var uploaderBodyView: some View {
        UploaderBubbleView(
            chat: store.peepBody,
            showMoreButtonTapped: { _ in store.send(.showMoreButtonTapped(chat: store.peepBody)) }
        )
    }

    private var enterFieldView: some View {
        HStack(alignment: .bottom) {
            TextField(
                "채팅을 입력해주세요",
                text: $store.message,
                axis: .vertical
            )
            .font(
                Font.custom(
                    PeepItFont.body04.style,
                    size: PeepItFont.body04.size
                )
            )
            .autocorrectionDisabled(true)
            .tint(Color.coreLime)
            .lineLimit(5)
            .frame(minHeight: 20)
            .padding(.vertical, 12)
            .padding(.horizontal, enterFieldHorizontalInset)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray700)
            )
            .onChange(of: store.message) { newText in
                let width = Constant.screenWidth
                - enterFieldHorizontalInset*2
                - 8 - enterViewPadding*2
                - sendButtonWidth

                store.send(
                    .checkIfEnterMessageLong(
                        lineCount: calculateNumberOfLines(text: newText, width: width)
                    )
                )
            }

            Spacer()
            sendButton
        }
        .padding(.horizontal, enterViewPadding)
    }


    private var sendButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.coreLime)
            Image("BoxBtnN")
        }
        .frame(width: 44, height: 44)
        .onTapGesture {
            store.send(.sendButtonTapped)
            endTextEditing()
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        sendButtonWidth = geo.size.width
                    }
            }
        )
    }

    @ViewBuilder
    private func originalBubbleView(chat: Chat) -> some View {
        if chat.type == .mine {
            OriginalChatBubbleView(chat: chat)
        } else {
            HStack(alignment: .top, spacing: 10) {
                Image("ProfileSample")
                    .resizable()
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 7) {
                        Text(chat.user.nickname)
                            .pretendard(.caption03)
                        Text("0분 전")
                            .pretendard(.caption04)
                    }
                    OriginalChatBubbleView(chat: chat)
                }
                Spacer()
            }
        }
    }

    private var chatList: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(store.chats, id: \.id) { chat in
                    switch chat.type {
                    case .mine:
                        MyChatBubbleView(
                            chat: chat,
                            showMoreButtonTapped: { _ in
                                endTextEditing()
                                store.send(.showMoreButtonTapped(chat: chat))
                            }
                        )
                    default:
                        ChatBubbleView(
                            chat: chat,
                            showMoreButtonTapped: { _ in
                                endTextEditing()
                                store.send(.showMoreButtonTapped(chat: chat))
                            }
                        )
                    }
                }

            }        }
        .padding(.horizontal)
        .scrollIndicators(.never)
    }
}

extension ChatView {

    /// 키보드 옵저버 등록
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

    /// 키보드 옵저버 삭제
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    /// 입력창 줄 수 세기
    private func calculateNumberOfLines(text: String, width: CGFloat) -> Int {
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let font = UIFont(name: PeepItFont.body04.style, size: PeepItFont.body04.size) ?? UIFont.systemFont(ofSize: 14)
        let boundingBox = (text as NSString).boundingRect(
            with: constraintSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        let lineHeight = PeepItFont.body04.lineHeight
        return Int(ceil(boundingBox.height / lineHeight))
    }
}

#Preview {
    ChatView(
        store: .init(initialState: ChatStore.State()) { ChatStore() }
    )
}
