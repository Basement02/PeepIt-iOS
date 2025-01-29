//
//  ThumbnailAlarm.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import SwiftUI

struct ThumbnailAlarm: View {
    let peep: Peep

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)

            ThumbnailLayer.primary()

            ThumbnailLayer.secondary()

            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.coreLime, lineWidth: 1)

            HStack(spacing: 1) {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 20.16, height: 20.16)
                Text("00")
                    .pretendard(.body01)
            }
            .frame(height: 22)
            .padding(.top, 10.8)
            .padding(.leading, 12)
        }
        .frame(width: 110.4, height: 151.2)
    }
}

#Preview {
    ThumbnailAlarm(peep: .stubPeep0)
}
