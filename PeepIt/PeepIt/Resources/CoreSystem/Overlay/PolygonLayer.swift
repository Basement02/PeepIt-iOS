//
//  PolygonLayer.swift
//  PeepIt
//
//  Created by 김민 on 2/3/25.
//

import SwiftUI

struct PolygonLayer: View {

    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.white, location: 0),
                .init(color: Color.white.opacity(0), location: 0.38),
                .init(color: Color.white.opacity(0), location: 0.83),
                .init(color: Color.white, location: 1),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .opacity(0.6)
    }
}

