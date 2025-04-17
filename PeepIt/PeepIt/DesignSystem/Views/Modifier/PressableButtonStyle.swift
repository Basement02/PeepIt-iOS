//
//  PressableButtonStyle.swift
//  PeepIt
//
//  Created by 김민 on 11/18/24.
//

import SwiftUI

enum ButtonColorStyle {
    case lime
    case gray900
    case base
    case white

    var normalColor: Color {
        switch self {
        case .lime:
            return .coreLime
        case .gray900:
            return .gray900
        case .base:
            return .base
        case .white:
            return .white
        }
    }

    var pressedColor: Color {
        switch self {
        case .lime:
            return .coreLimeClick
        case .gray900:
            return .gray600
        case .base:
            return .gray700
        case .white:
            return .gray100
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    let colorStyle: ButtonColorStyle

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(1)
            .background(configuration.isPressed ? colorStyle.pressedColor : colorStyle.normalColor)
    }
}

struct PressableOpacityButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct PressableViewButtonStyle<NormalView: View, PressedView: View>: ButtonStyle {
    let normalView: NormalView
    let pressedView: PressedView

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if configuration.isPressed {
                pressedView
            } else {
                normalView
            }

            configuration.label
        }
    }
}

struct MainButtonStyle: ViewModifier {
    var width: CGFloat
    var height: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .pretendard(.foodnote)
    }
}

extension View {

    func mainButtonStyle(width: CGFloat = 250, height: CGFloat = 55) -> some View {
        self.modifier(MainButtonStyle(width: width, height: height))
    }
}
