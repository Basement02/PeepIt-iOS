//
//  ElseMenuView.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import SwiftUI

struct ElseMenuView<First: View, Second: View>: View {
    var firstButton: First
    var secondButton: Second
    let bgColor: Color

    var body: some View {
        VStack(spacing: 9) {
            firstButton

            Rectangle()
                .frame(width: 108, height: 0.45)
                .foregroundStyle(Color.op)

            secondButton
        }
        .padding(.vertical, 17)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(bgColor)
                .frame(width: 146)
        )
    }
}
