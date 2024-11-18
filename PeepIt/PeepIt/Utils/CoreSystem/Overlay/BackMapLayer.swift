//
//  BackMapLayer.swift
//  PeepIt
//
//  Created by 김민 on 11/18/24.
//

import SwiftUI

struct BackMapLayer: View {
    let color: Color
    let startPoint: UnitPoint = .top
    let endPoint: UnitPoint = .bottom
    let opacity: CGFloat

    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: color.opacity(0.2), location: 0),
                .init(color: color.opacity(0), location: 0.2),
                ]),
            startPoint: startPoint,
            endPoint: endPoint)
        .opacity(opacity)
    }
}

extension BackMapLayer {

    static func teriary() -> some View {
        ZStack {
            BackMapLayer(color: Color.white, opacity: 0.2)
            BackMapLayer(color: Color(hex: 0x2F360F), opacity: 1.0)
        }
    }

    static func secondary() -> some View {
        Color(hex: 0xDADADA, alpha: 0.2)
    }
}
