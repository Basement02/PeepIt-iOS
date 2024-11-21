//
//  HotLabel.swift
//  PeepIt
//
//  Created by 김민 on 11/21/24.
//

import SwiftUI

struct HotLabel: View {
    
    var body: some View {
        HStack(spacing: 0) {
            Image("IconPopular")
            Text("인기")
                .pretendard(.caption02)
                .foregroundStyle((Color(hex: 0x202020)))
        }
        .padding(.leading, 6)
        .padding(.trailing, 10)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.coreLime)
        )
    }
}

#Preview {
    HotLabel()
}
