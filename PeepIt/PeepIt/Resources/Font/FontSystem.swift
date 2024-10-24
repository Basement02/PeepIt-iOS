//
//  FontSystem.swift
//  PeepIt
//
//  Created by 김민 on 10/25/24.
//

import SwiftUI

enum PeepItFont {
    case title01
    case title02
    case title03
    case headline
    case subhead
    case body01
    case body02
    case body03
    case body04
    case body05
    case foodnote
    case caption01
    case caption02
    case caption03
    case caption04

    var style: String {
        switch self {
        case .title01, .title02, .headline, .foodnote:
            return "Pretendard-Bold"

        case .title03, .subhead, .caption01, .caption02:
            return "Pretendard-SemiBold"

        case .body01, .caption03, .caption04:
            return "Pretendard-Regular"

        case .body02, .body03, .body04, .body05:
            return "Pretendard-Medium"
        }
    }

    var size: CGFloat {
        switch self {
        case .title01:
            return 28
        case .title02:
            return 23
        case .title03:
            return 20
        case .headline, .subhead, .body01:
            return 17
        case .body02, .body03, .foodnote:
            return 16
        case .body04, .body05, .caption03:
            return 14
        case .caption01:
            return 13
        case .caption02, .caption04:
            return 12
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .title01:
            return 34
        case .title02:
            return 30
        case .title03:
            return 28
        case .headline, .body05:
            return 23
        case .subhead, .body01, .body02, .body04:
            return 22
        case .body03:
            return 24
        case .foodnote:
            return 19
        case .caption01, .caption03:
            return 17
        case .caption02:
            return 14
        case .caption04:
            return 15
        }
    }

    var letterSpacing: CGFloat {
        switch self {
        case .title01:
            return 0.38
        case .title02, .headline:
            return 0.0
        case .title03:
            return -0.45
        case .subhead, .body01, .body02, .body04:
            return -0.43
        case .body03:
            return -0.23
        case .body05, .foodnote:
            return -0.15
        case .caption01, .caption03:
            return -0.08
        case .caption02:
            return -0.06
        case .caption04:
            return -0.4
        }
    }

    var peepItFont: Font {
        return .custom(self.style, size: self.size)
    }
}
