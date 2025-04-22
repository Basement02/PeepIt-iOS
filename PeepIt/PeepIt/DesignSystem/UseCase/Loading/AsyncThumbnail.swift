//
//  AsyncThumbnail.swift
//  PeepIt
//
//  Created by 김민 on 4/17/25.
//

import SwiftUI

struct AsyncThumbnail: View {
    let imgStr: String?

    @State private var thumbnail: UIImage?

    var body: some View {
        Group {
             if let image = thumbnail {
                 Image(uiImage: image)
                     .resizable()
                     .scaledToFill()
                     .clipped()
             } else {
                 Rectangle()
                     .fill(Color.gray900)
                     .onAppear { loadThumbnail() }
             }
         }
    }

    private func loadThumbnail() {
        guard
            let imgStr,
            let url = URL(string: imgStr)
        else { return }

        url.loadThumbnail { image in
            self.thumbnail = image
        }
    }
}

#Preview {
    AsyncThumbnail(imgStr: "https://peepit-prod-bucket.s3.ap-northeast-2.amazonaws.com//peep274f4423-1f71-4324-a038-1fc6bed4624f_스크린샷 2025-04-17 오후 9.17.28.png")
        .frame(width: 133, height: 155)
}
