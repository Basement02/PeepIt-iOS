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
        ZStack {
            Image("SampleImage")
                .resizable()

            ThumbnailLayer.primary()

            ThumbnailLayer.secondary()

            VStack {
                if let reaction = peep.reaction, !peep.isMine {
                    HStack {
                        Spacer()

                        ZStack {
                            RoundedRectangle(cornerRadius: 8.37)
                                .fill(Color.coreLimeOp)
                                .frame(width: 35, height: 35)

                            Text(reaction)
                                .font(.system(size: 16))
                        }
                    }
                }

                Spacer()

                if peep.isVideo {
                    HStack {
                        Image("IconVideo")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Spacer()
                    }
                }
            }
            .padding(.top, 8.5)
            .padding(.bottom, 7.5)
            .padding(.leading, 8)
            .padding(.trailing, 7)

            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                    Color.coreLime,
                    lineWidth: peep.isActive ? 1 : 0
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
