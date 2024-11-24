//
//  TagTab.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import SwiftUI

struct TagTab: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .pretendard(.caption02)
            .foregroundStyle(isSelected ? .white : .gray300)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(
                        isSelected ?
                        Color(hex: 0xA9D000) : Color.gray700
                    )
            }
    }
}

#Preview {
    VStack {
        TagTab(
            title: "태그",
            isSelected: true
        )

        TagTab(
            title: "태그",
            isSelected: false
        )
    }
}
