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
                Image("IconComment")
                    .resizable()
                    .frame(width: 16.8, height: 16.8)
                Text("00")
                    .pretendard(.body04)
            }
            .frame(height: 20)
            .padding(.top, 9)
            .padding(.leading, 10)
        }
        .frame(width: 92, height: 126)
    }
}

#Preview {
    ThumbnailAlarm(peep: .stubPeep0)
}
