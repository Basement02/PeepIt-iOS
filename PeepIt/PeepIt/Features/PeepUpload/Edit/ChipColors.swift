//
//  ChipColors.swift
//  PeepIt
//
//  Created by 김민 on 12/26/24.
//

import SwiftUI

enum ChipColors: CaseIterable, Hashable {
    case chipWhite
    case chipBlack
    case chipLime
    case chip02
    case chip08
    case chip07
    case chipRed
    case chip06
    case chip03
    case chip01
    case chip04
    case chip05

    var color: Color {
        switch self {
        case .chipWhite:
            return .white
        case .chipBlack:
            return .black
        case .chipLime:
            return .coreLime
        case .chip02:
            return Color(hex: 0x50C23B)
        case .chip08:
            return Color(hex: 0xFFC83F)
        case .chip07:
            return Color(hex: 0xFF8600)
        case .chipRed:
            return .coreRed
        case .chip06:
            return Color(hex: 0x9747FF)
        case .chip03:
            return Color(hex: 0x5475EC)
        case .chip01:
            return Color(hex: 0x47C5EF)
        case .chip04:
            return Color(hex: 0x633816)
        case .chip05:
            return Color(hex: 0x828282)
        }
    }
}
