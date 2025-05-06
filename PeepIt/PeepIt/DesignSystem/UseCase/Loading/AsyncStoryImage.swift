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

    private var mediaView: some View {
        Group {
            if let url = url {
                if isVideo {
                    LoopingVideoPlayerView(
                        videoURL: url,
                        isSoundOn: true,
                        isPlaying: true
                    )
                } else {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        placeholderView
                    }
                }
            } else {
                placeholderView
            }
        }
    }

    private var placeholderView: some View {
        Color.gray900
    }

    var body: some View {
        mediaView
            .aspectRatio(9/16, contentMode: .fit)
            .frame(width: Constant.screenWidth)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
