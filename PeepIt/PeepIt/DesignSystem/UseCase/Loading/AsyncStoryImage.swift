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

    @State private var angle: Double = 0
    @State private var timer: Timer?
    @State private var isReadyToPlay = false

    private var url: URL? {
        guard let str = dataURLStr else { return nil }
        return URL(string: str)
    }

    private var mediaView: some View {
        ZStack {
            if let url = URL(string: dataURLStr ?? "") {
                ZStack {
                    if isVideo {
                        LoopingVideoPlayerView(
                            videoURL: url,
                            isSoundOn: true,
                            isPlaying: true,
                            isReadyToPlay: $isReadyToPlay
                        )
                    } else {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            placeholderView
                        }
                    }

                    if isVideo && !isReadyToPlay { placeholderView }
                }
            } else {
                placeholderView
            }
        }
        .aspectRatio(9/16, contentMode: .fit)
        .frame(width: Constant.screenWidth)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var placeholderView: some View {
        Color.gray900
            .overlay {
                Image("IconPopularGray")
                    .rotationEffect(.degrees(angle))
                    .onAppear {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                            angle += 3
                            if angle >= 360 { angle -= 360 }
                        }
                    }
                    .onDisappear {
                        timer?.invalidate()
                        timer = nil
                    }
            }
    }

    var body: some View {
        mediaView
            .aspectRatio(9/16, contentMode: .fit)
            .frame(width: Constant.screenWidth)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
