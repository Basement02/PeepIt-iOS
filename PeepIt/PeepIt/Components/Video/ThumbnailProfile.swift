//
//  ThumbnailProfile.swift
//  PeepIt
//
//  Created by 김민 on 11/24/24.
//

import SwiftUI

struct ThumbnailProfile: View {
    let peep: Peep

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // TODO: 이미지로 변경
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)

            ThumbnailLayer.primary()

            ThumbnailLayer.secondary()

            if let reaction = peep.reaction, !peep.isMine {
                ZStack {
                    RoundedRectangle(cornerRadius: 8.37)
                        .fill(Color.coreLimeOp)
                        .frame(width: 35, height: 35)

                    Text(reaction)
                        .font(.system(size: 16))
                }
                .padding(.top, 9)
                .padding(.trailing, 8)
            }

            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                    Color.coreLime,
                    lineWidth: peep.isActive ? 1 : 0
                )
        }
        .frame(
            width: Constant.isSmallDevice ? 108 : 113,
            height: Constant.isSmallDevice ? 148 : 155
        )
    }
}

#Preview {
    HStack {
        ThumbnailProfile(
            peep: .stubPeep0
        )

        ThumbnailProfile(
            peep: .stubPeep1
        )
    }
}
