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

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                Color.black.opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        closeChatButton
                    }
                    .padding(.bottom, 48)

                    uploaderBody

                    ScrollView {
                        ForEach(store.chats, id: \.self) { chat in
                            ChatBubbleView(chat: chat)
                        }
                    }
                    .padding(.vertical, 15)
                    Spacer()

                    chatTextField
                        .padding(.bottom, 35)
                }
                .padding(.horizontal, 17)
            }
            .onAppear {
                store.send(.loadChats)
            }
        }
    }

    private var closeChatButton: some View  {
        Button {
            store.send(.closeChatButtonTapped)
        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }

    private var uploaderBody: some View {
        HStack(alignment: .top, spacing: 13) {
            Circle()
                .frame(width: 28, height: 28)

            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text("닉네임")
                    Text("n시간 전")
                }

                Text("본문 내용이 들어갑니다 본문 내용이 들어갑니다 본문 내용이 들어갑니다 본문 내용이 들어갑니다 본문 내용이 들어갑니다 본문 내용이 들어갑니다")
            }
            .font(.system(size: 11))
        }
        .padding(.vertical, 17)
        .padding(.horizontal, 13)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.gray)
        )
    }

    private var chatTextField: some View {
        HStack {
            TextField("", text: $store.message)
            Spacer()
            sendButton
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(lineWidth: 1)
                .frame(height: 40)
        )
    }

    private var sendButton: some View {
        Button {
            store.send(.sendButtonTapped)
        } label: {
            Text("전송")
        }
    }
}

#Preview {
    ChatView(
        store: .init(initialState: ChatStore.State()) { ChatStore() }
    )
}
