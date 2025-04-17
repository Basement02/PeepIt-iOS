//
//  TitleTab.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import SwiftUI

struct TitleTab: View {
    let icnSelected: String
    let icnNotSelected: String
    let title: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 2) {
                Image(isSelected ? icnSelected : icnNotSelected)
                Text(title)
                    .pretendard(.foodnote)
                    .foregroundStyle(
                        isSelected ? Color.coreLime : Color.gray300
                    )
            }

            Rectangle()
                .fill(isSelected ? Color.coreLime : Color.gray300)
                .frame(height: 1)
        }
        .frame(width: 180)
    }
}

#Preview {
    HStack {
        TitleTab(
            icnSelected: "IconPeepSelected",
            icnNotSelected: "IconPeepNotSelected",
            title: "나의 핍",
            isSelected: true
        )

        TitleTab(
            icnSelected: "IconStarSelected",
            icnNotSelected: "IconStarNotSelected",
            title: "나의 활동",
            isSelected: false
        )
    }
}
