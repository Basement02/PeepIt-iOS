//
//  BackImageLayer.swift
//  PeepIt
//
//  Created by 김민 on 11/18/24.
//

import SwiftUI

struct BackImageLayer: View {
    let gradient: Gradient
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    let opacity: CGFloat

    var body: some View {
        LinearGradient(
            gradient: gradient,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .opacity(opacity)
    }
}

extension BackImageLayer {

    static func primary() -> BackImageLayer {
        return BackImageLayer(
            gradient: Gradient(stops: [
                .init(color: Color(hex: 0x262822), location: 0),
                .init(color: Color(hex: 0x262822, alpha: 0.2), location: 0.14),
                .init(color: Color(hex: 0x262822, alpha: 0), location: 0.51),
                .init(color: Color(hex: 0x262822, alpha: 0.2), location: 0.85),
                .init(color: Color(hex: 0x262822), location: 1),
            ]),
            startPoint: .leading,
            endPoint: .trailing,
            opacity: 0.2
        )
    }

    static func secondary() -> BackImageLayer {
        return BackImageLayer(
            gradient: Gradient(stops: [
                .init(color: Color(hex: 0x202020, alpha: 0.8), location: 0),
                .init(color: Color(hex: 0x202020, alpha: 0.4), location: 0.17),
                .init(color: Color(hex: 0x202020, alpha: 0.1), location: 0.25),
                .init(color: Color(hex: 0x202020, alpha: 0.0), location: 0.51),
                .init(color: Color(hex: 0x202020, alpha: 0.1), location: 0.74),
                .init(color: Color(hex: 0x202020), location: 0.88),
            ]),
            startPoint: .top,
            endPoint: .bottom,
            opacity: 0.2
        )
    }
}
