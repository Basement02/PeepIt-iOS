//
//  ChatView.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {
    let store: StoreOf<ChatStore>

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Color.black.opacity(0.2)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    closeChatButton
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
    }
}

extension ChatView {

    private var closeChatButton: some View  {
        Button {
            store.send(.closeChatButtonTapped)
        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    ChatView(
        store: .init(initialState: ChatStore.State()) { ChatStore() }
    )
}
