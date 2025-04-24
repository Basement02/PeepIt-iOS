//
//  PeepPreviewThumbnail.swift
//  PeepIt
//
//  Created by 김민 on 3/2/25.
//

import SwiftUI

struct PeepPreviewThumbnail: View {
    let peep: Peep

    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                AsyncThumbnail(imgStr: peep.data)
                ThumbnailLayer.primary()
                ThumbnailLayer.secondary()
            }
            .frame(width: 281, height: 384)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Image("IconPeep")
                    Text("현재 위치에서 0km") // TODO:
                    Spacer()
                    hotLabel
                }
                .pretendard(.body05)
                .foregroundStyle(Color.white)

                Spacer()

                profileView
            }
            .padding(.top, 19)
            .padding(.bottom, 20)
            .frame(width: 250)
            .padding(.leading, 16)
            // TODO: - 활성화 핍 border
        }
        .frame(width: 281, height: 384)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            if peep.isActive {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.coreLime, lineWidth: 1)
            }
        }
    }

    private var hotLabel: some View {
        HStack(spacing: 0) {
            Image("IconPopular")
            Text("인기")
                .pretendard(.caption02)
                .foregroundStyle((Color(hex: 0x202020)))
        }
        .padding(.leading, 6)
        .padding(.trailing, 10)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.coreLime)
        )
    }

    private var profileView: some View {
        HStack {
            Image("ProfileSample")
                .resizable()
                .frame(width: 25, height: 25)

            Text(peep.writerId) // TODO:
                .pretendard(.body02)

            Spacer()

            Text("3분 전")
                .pretendard(.caption04)
        }
        .foregroundStyle(Color.white)
    }
}

#Preview {
    PeepPreviewThumbnail(peep: .stubPeep0)
}
