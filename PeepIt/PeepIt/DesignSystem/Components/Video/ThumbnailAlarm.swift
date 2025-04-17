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
        ZStack {
            AsyncThumbnail(imgStr: peep.data)
            ThumbnailLayer.primary()
            ThumbnailLayer.secondary()

            VStack {
                HStack(spacing: 1) {
                    Image("IconCommentBoldFrame")
                    Text("\(peep.chatNum)")
                        .pretendard(.body01)
                    Spacer()
                }

                Spacer()

                if peep.isVideo {
                    HStack {
                        Image("IconVideo")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Spacer()
                    }
                }
            }
            .frame(width: 94, height: 134)
        }
        .frame(width: 110, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            if peep.isActive {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.coreLime, lineWidth: 1)
            }
        }
    }
}

#Preview {
    HStack {
        ThumbnailAlarm(peep: .stubPeep0)
        ThumbnailAlarm(peep: .stubPeep1)
    }
}
