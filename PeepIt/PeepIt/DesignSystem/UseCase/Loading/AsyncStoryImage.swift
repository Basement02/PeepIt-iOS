//
//  AsyncStoryImage.swift
//  PeepIt
//
//  Created by 김민 on 4/27/25.
//

import SwiftUI

struct AsyncStoryImage: View {
    let dataURLStr: String?
    let isVideo: Bool

    private var url: URL? {
        guard let str = dataURLStr else { return nil }
        return URL(string: str)
    }

    var body: some View {
        Group {
            if let url = url {
                if isVideo {
                    LoopingVideoPlayerView(
                        videoURL: url,
                        isSoundOn: true,
                        isPlaying: true
                    )
                    .frame(width: Constant.screenWidth, height: Constant.screenWidth * 16/9)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(9/16, contentMode: .fit)
                            .frame(width: Constant.screenWidth)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        
                    } placeholder: {
                        Color.base
                    }
                }
            } else {
                Color.base
                    .aspectRatio(9/16, contentMode: .fit)
                    .frame(width: Constant.screenWidth)
            }
        }
    }
}
