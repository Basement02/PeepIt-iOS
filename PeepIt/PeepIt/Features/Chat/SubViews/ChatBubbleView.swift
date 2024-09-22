//
//  ChatBubbleView.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import SwiftUI

struct ChatBubbleView: View {
    let chat: Chat

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if chat.type != .mine {
                profileView
                    .padding(.leading, 3)
            }

            HStack(alignment: .bottom) {
                if chat.type == .mine {
                    Spacer()
                    dateView
                }

                Text(chat.message)
                    .lineLimit(nil)
                    .font(.system(size: 14))
                    .padding(.all, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(chat.type.backgroundColor)
                    )

                if chat.type != .mine {
                    dateView
                    Spacer()
                }
            }
        }
    }

    private var profileView: some View {
        HStack(spacing: 6) {
            Circle()
                .frame(width: 19, height: 19)
            Text(chat.user.nickname)
                .font(.system(size: 11))
        }
    }

    private var dateView: some View {
        Text(chat.sendTime)
            .font(.system(size: 11))
    }
}

#Preview {
    Group {
        ChatBubbleView(chat: .chatStub1)
        ChatBubbleView(chat: .chatStub2)
    }
}
