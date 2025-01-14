//
//  ChatBubbleView.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import SwiftUI

struct ChatBubbleView: View {
    let chat: Chat

    @State private var isTrunscated = false

    var body: some View {
        ZStack {
            /// 크기 측정 위한 뷰
            if !isTrunscated {
                Text(chat.message.forceCharWrapping)
                    .lineLimit(nil)
                    .pretendard(.body04)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    if geo.size.height >= 101 {
                                        isTrunscated = true
                                    }
                                }
                        }
                    )
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .opacity(0)
            }

            VStack(spacing: 0) {
                /// 진짜 채팅 뷰
                Text(chat.message.forceCharWrapping)
                    .pretendard(.body04)
                    .lineLimit(5)
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    .padding(.bottom, isTrunscated ? 36 : 12)
                    .background(
                        ZStack(alignment: .bottomTrailing) {
                            Rectangle()
                                .fill(bgColor(type: chat.type))
                                .makeCorner(of: chat.type)

                            if isTrunscated {
                                Text("더보기")
                                    .pretendard(.caption02)
                                    .foregroundStyle(Color.nonOp)
                                    .padding(.bottom, 12)
                                    .padding(.trailing, 14)
                            }
                        }
                    )
            }
        }
        .frame(
            maxWidth: 225 + 14 * 2,
            alignment: chat.type == .mine ? .trailing : .leading
        )
    }

    private func bgColor(type: ChatType) -> Color {
        switch chat.type {
        case .mine:
            return Color.base
        case .others:
            return Color.elevated
        case .uploader:
            return Color.coreLimeDOp
        }
    }
}

extension View {

    func makeCorner(of chatType: ChatType) -> some View {
        switch chatType {

        case .mine:
            return AnyView(
                self
                    .roundedCorner(13.2, corners: .topLeft)
                    .roundedCorner(13.2, corners: .bottomLeft)
                    .roundedCorner(17.6, corners: .bottomRight)
            )

        case .uploader, .others:
            return AnyView(
                self
                    .roundedCorner(13.2, corners: .topRight)
                    .roundedCorner(13.2, corners: .bottomRight)
                    .roundedCorner(17.6, corners: .bottomLeft)
            )
        }
    }
}

#Preview {
    VStack(spacing: 0) {
//        ChatBubbleView(chat: .chatStub1)
//        ChatBubbleView(chat: .chatStub3)
        ChatBubbleView(chat: .chatStub4)
//        ChatBubbleView(chat: .chatStub6)
    }
}
