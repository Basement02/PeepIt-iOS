//
//  ColorChip.swift
//  PeepIt
//
//  Created by 김민 on 12/26/24.
//

import SwiftUI

struct ColorChip: View {
    let color: Color

    var body: some View {
        ZStack {
            Ellipse()
                .fill(color)
                .frame(width: 32, height: 45)

            Ellipse()
                .stroke(style: .init(lineWidth: 1))
                .fill(.white)
                .frame(width: 32, height: 45)
        }
        .rotationEffect(.degrees(47.34))
        .frame(width: 55, height: 55)
    }
}

#Preview {
    ColorChip(color: Color.coreLime)
}
