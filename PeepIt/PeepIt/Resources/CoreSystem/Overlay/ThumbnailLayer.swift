//
//  ThumbnailLayer.swift
//  PeepIt
//
//  Created by 김민 on 11/18/24.
//

import SwiftUI

struct ThumbnailLayer: View {
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    let opacity: CGFloat

    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(hex: 0x262822), location: 0),
                .init(color: Color(hex: 0x262822, alpha: 0.2), location: 0.33),
                .init(color: Color(hex: 0x262822, alpha: 0), location: 0.51),
                .init(color: Color(hex: 0x262822, alpha: 0.2), location: 0.67),
                .init(color: Color(hex: 0x262822), location: 1),
            ]),
            startPoint: startPoint,
            endPoint: endPoint
        )
        .opacity(opacity)
    }
}

extension ThumbnailLayer {

    static func primary() -> ThumbnailLayer {
        return ThumbnailLayer(startPoint: .leading, endPoint: .trailing, opacity: 0.5)
    }

    static func secondary() -> ThumbnailLayer {
        return ThumbnailLayer(startPoint: .top, endPoint: .bottom, opacity: 0.6)
    }
}
