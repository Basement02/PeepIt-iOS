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

                        Text(description.forceCharWrapping)
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
        title: "이미 사용 중인 번호입니다.",
        description: "입력된 전화번호가 올바른지 다시 한 번 확인해주세요.",
        buttonLabel: "네",
        action: { }
    )
}
