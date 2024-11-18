//
//  DropShadowModifier.swift
//  PeepIt
//
//  Created by 김민 on 11/18/24.
//

import SwiftUI

struct DropShadowModifier: ViewModifier {
    let blur: CGFloat
    let opacity: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color(hex: 0x202020, alpha: opacity),
                radius: blur / 2,
                x: 0,
                y: 4
            )
    }
}

extension View {

    func shadowPoint() -> some View {
        self.modifier(DropShadowModifier(blur: 10, opacity: 0.3))
    }

    func shadowElement() -> some View {
        self.modifier(DropShadowModifier(blur: 10, opacity: 0.15))
    }

    func shadowLine() -> some View {
        self.modifier(DropShadowModifier(blur: 4, opacity: 0.25))
    }
}
