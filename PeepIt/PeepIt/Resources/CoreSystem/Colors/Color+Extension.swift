//
//  Color+Extension.swift
//  PeepIt
//
//  Created by 김민 on 10/22/24.
//

import SwiftUI

extension Color {

    /// Background Base
    static let base: Color = .init(hex: 0x202020)
    static let blur1: Color = .init(hex: 0x202020, alpha: 0.85)
    static let blur2: Color = .init(hex: 0x202020, alpha: 0.6)
    static let elevated: Color = .init(hex: 0x848484, alpha: 0.4)

    /// Element Point
    static let coreLime: Color = .init(hex: 0xCEFF00)
    static let coreRed: Color = .init(hex: 0xFF5959)
    static let coreLimeDOp: Color = .init(hex: 0x6B8400, alpha: 0.5)
    static let coreLimeOp: Color = Color.coreLime.opacity(0.5)
    static let coreLimeClick: Color = .init(hex: 0xA9D000)

    /// Element Basic
    static let gray900: Color = .init(hex: 0x2F2F2F)
    static let gray800: Color = .init(hex: 0x38393B)
    static let gray700: Color = .init(hex: 0x3E3E3E)
    static let gray600: Color = .init(hex: 0x4F4F4F)
    static let gray500: Color = .init(hex: 0x575757)
    static let gray400: Color = .init(hex: 0x6B6B6B)
    static let gray300: Color = .init(hex: 0xA3A3A3)
    static let gray100: Color = .init(hex: 0xE6E6EB)

    /// Separator
    static let op: Color = .init(hex: 0xFFFFFF, alpha: 0.2)
    static let nonOp: Color = .init(hex: 0xFFFFFF, alpha: 0.5)
}

extension Color {

    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
