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
                Color.base
                    .ignoresSafeArea()

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

                Group {
                    BackImageLayer.primary()
                    BackImageLayer.secondary()
                    Color.blur2
                }
                .ignoresSafeArea()

                VStack(spacing: 11.adjustedH) {
                    topBar

                    Spacer()
                }

            }
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                store.send(.loadChats)
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
