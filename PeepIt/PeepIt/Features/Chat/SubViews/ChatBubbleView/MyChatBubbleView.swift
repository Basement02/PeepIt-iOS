//
//  MyChatBubbleView.swift
//  PeepIt
//
//  Created by 김민 on 3/5/25.
//

import SwiftUI

struct MyChatBubbleView: View {
    let chat: Chat
    let showMoreButtonTapped: ((Chat) -> Void)?

    @State private var isTruncated = false

    var body: some View {
        HStack {
            Spacer()
            ZStack {
                /// 크기 측정 위한 뷰
                if !isTruncated {
                    Text(chat.message.forceCharWrapping)
                        .lineLimit(nil)
                        .pretendard(.body04)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        if geo.size.height >= 101 {
                                            isTruncated = true
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
                        .padding(.bottom, isTruncated ? 36 : 12)
                        .background(
                            ZStack(alignment: .bottomTrailing) {
                                Rectangle()
                                    .fill(chat.type.backgroundColor)
                                    .makeCorner(of: chat.type)

                                if isTruncated {
                                    Text("더보기")
                                        .pretendard(.caption02)
                                        .foregroundStyle(Color.nonOp)
                                        .padding(.bottom, 12)
                                        .padding(.trailing, 14)
                                        .onTapGesture { showMoreButtonTapped?(chat) }
                                }
                            }
                        )
                }
            }
            .frame(maxWidth: 225 + 14 * 2, alignment: .trailing)
            .onAppear { isTruncated = false }
            .gesture(
                LongPressGesture(minimumDuration: 0.4)
                    .onEnded { isPressed in
                        if isPressed { showMoreButtonTapped?(chat) }
                    }
            )
        }
    }
}
