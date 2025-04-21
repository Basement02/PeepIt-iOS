//
//  AsyncThumbnail.swift
//  PeepIt
//
//  Created by 김민 on 4/17/25.
//

import SwiftUI

struct AsyncThumbnail: View {
    let imgStr: String?

    var body: some View {
        AsyncImage(url: URL(string: imgStr ?? "")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.gray900)
            }
        }
    }
}

#Preview {
    AsyncThumbnail(imgStr: "https://peepit-prod-bucket.s3.ap-northeast-2.amazonaws.com//peep274f4423-1f71-4324-a038-1fc6bed4624f_스크린샷 2025-04-17 오후 9.17.28.png")
        .frame(width: 133, height: 155)
}
