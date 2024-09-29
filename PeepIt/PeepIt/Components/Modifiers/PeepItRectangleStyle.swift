//
//  PeepItRectangleStyle.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI

struct PeepItRectangleStyle: ViewModifier {
    var backgroundColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 38)
            .foregroundStyle(textColor)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(backgroundColor)
            )
    }
}

extension View {
    
    func peepItRectangleStyle(
        backgroundColor: Color = .black,
        textColor: Color = .white
    ) -> some View {
        self.modifier(
            PeepItRectangleStyle(backgroundColor: backgroundColor, textColor: textColor)
        )
    }
}
