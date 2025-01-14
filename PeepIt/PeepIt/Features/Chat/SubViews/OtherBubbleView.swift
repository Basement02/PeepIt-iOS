//
//  OtherBubbleView.swift
//  PeepIt
//
//  Created by 김민 on 1/15/25.
//

import SwiftUI

struct OtherBubbleView: View {
    let chat: Chat

    var body: some View {
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

                ChatBubbleView(chat: chat)
            }

            Spacer()
        }
    }
}

#Preview {
    VStack {
        OtherBubbleView(chat: .chatStub1)
    }
}
