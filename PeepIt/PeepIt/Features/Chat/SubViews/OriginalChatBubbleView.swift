//
//  OriginalChatBubbleView.swift
//  PeepIt
//
//  Created by 김민 on 1/16/25.
//

import SwiftUI

struct OriginalChatBubbleView: View {
    let chat: Chat

    var body: some View {
        HStack {
            if chat.type == .mine { Spacer() }

            VStack {
                Text(chat.message.forceCharWrapping)
                    .pretendard(.body04)
                    .lineLimit(25)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        Rectangle()
                            .fill(chat.type.backgroundColor)
                            .makeCorner(of: chat.type)
                    )
            }
            .frame(
                maxWidth: 225 + 14 * 2,
                alignment: chat.type == .mine ? .trailing : .leading
            )

            if chat.type != .mine { Spacer() }
        }
    }
}

#Preview {
    VStack {
        OriginalChatBubbleView(chat: .chatStub4)
        OriginalChatBubbleView(chat: .chatStub2)
        OriginalChatBubbleView(chat: .chatStub6)
    }
}
