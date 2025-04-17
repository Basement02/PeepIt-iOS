//
//  EnterFieldWithCheck.swift
//  PeepIt
//
//  Created by 김민 on 4/17/25.
//

import SwiftUI

/// 입력창 enum 정의
enum EnterState: Equatable {
    case base
    case completed
    case error

    var foregroundColor: Color {
        switch self {
        case .base:
            return .white
        case .completed:
            return .coreLime
        case .error:
            return .coreRed
        }
    }
}

struct EnterFieldWithCheck: View {
    let obj: String

    @Binding var text: String
    @Binding var validState: EnterState
    @Binding var guideMessage: String

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(obj)
                .pretendard(.caption01)
                .padding(.bottom, 20)

            HStack {
                TextField(
                    "\(obj.withObjectParticle) 입력해 주세요.",
                    text: $text
                )
                .focused($isFocused)
                .pretendard(.body02)
                .tint(
                    validState == .base ?
                    Color.coreLime : Color.white
                )
                .frame(height: 29.4)

                Spacer()

                Group {
                    switch validState {
                    case .base:
                        Image("IconOKsign")
                    case .completed:
                        Image("IconOKsignLime")
                    case .error:
                        Image("IconNOsign")
                    }
                }
            }
            .padding(.bottom, 10)

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(validState.foregroundColor)
                .padding(.bottom, 10)

            Text(guideMessage)
                .pretendard(.caption03)
                .foregroundStyle(validState.foregroundColor)
        }
        .onAppear { isFocused = true }
    }
}

#Preview {
    EnterFieldWithCheck(
        obj: "닉네임",
        text: .constant(""),
        validState: .constant(.base),
        guideMessage: .constant("가이드 문구")
    )
}
