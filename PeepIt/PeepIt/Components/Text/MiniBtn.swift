//
//  MiniBtn.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import SwiftUI

struct MiniBtn: View {
    var width: CGFloat = CGFloat(140)
    var title: String
    var bg: Color = Color.gray600

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(bg)
                .frame(width: width, height: 42)

            Text(title)
                .pretendard(.caption01)
        }
    }
}

#Preview {
    MiniBtn(title: "텍스트")
}
