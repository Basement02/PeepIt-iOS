//
//  FontModifier.swift
//  PeepIt
//
//  Created by 김민 on 10/25/24.
//

import SwiftUI

struct FontModifier: ViewModifier {
    let font: PeepItFont

    func body(content: Content) -> some View {
        let spacer = (font.lineHeight - font.size) / 2

        return content
            .font(font.peepItFont)
            .lineSpacing(spacer)
            .padding(.vertical, spacer)
            .tracking(font.letterSpacing)
    }
}

extension View {

    func pretendard(_ font: PeepItFont) -> some View {
        self.modifier(FontModifier(font: font))
    }
}
