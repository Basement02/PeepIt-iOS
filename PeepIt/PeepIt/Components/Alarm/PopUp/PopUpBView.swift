//
//  PopUpAView.swift
//  PeepIt
//
//  Created by 김민 on 3/31/25.
//

import SwiftUI

struct PopUpBView: View {
    let title: String
    let description: String
    let buttonLabel: String
    let action: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray600)

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 11) {
                        Text(title)
                            .pretendard(.title03)

                        Text(description)
                            .pretendard(.body03)
                            .frame(height: 71, alignment: .topLeading)
                    }

                    Spacer()
                }
                .padding(.horizontal, 5)
                .frame(width: 294, height: 110)

                Button {
                    action()
                } label: {
                    Text(buttonLabel)
                        .pretendard(.headline)
                        .foregroundStyle(Color.gray600)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .frame(width: 289, height: 50)
                .background(Color.coreLime)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .frame(width: 329, height: 222)
    }
}

#Preview {
    PopUpBView(
        title: "알림 제목",
        description: "알림 내용",
        buttonLabel: "텍스트",
        action: { print("hello") }
    )
}
