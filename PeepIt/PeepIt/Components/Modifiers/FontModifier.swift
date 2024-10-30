//
//  FontModifier.swift
//  PeepIt
//
//  Created by 김민 on 10/25/24.
//

import SwiftUI
import UIKit

struct FontModifier: ViewModifier {
    let font: PeepItFont

    func body(content: Content) -> some View {
        let spacer = (font.lineHeight - getFontLineHeight(of: font))

        return content
            .font(font.peepItFont)
            .lineSpacing(spacer)
            .padding(.vertical, spacer / 2)
            .tracking(font.letterSpacing)
    }

    func getFontLineHeight(of font: PeepItFont) -> CGFloat {
        guard let customFont = UIFont(
            name: font.style, size: font.size
        ) else { return 0 }
        
        return customFont.lineHeight
    }
}

extension View {

    func pretendard(_ font: PeepItFont) -> some View {
        self.modifier(FontModifier(font: font))
    }
}
