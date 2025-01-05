//
//  LoopingVideoPlayerView.swift
//  PeepIt
//
//  Created by 김민 on 1/6/25.
//

import AVFoundation
import UIKit
import SwiftUI

struct LoopingVideoPlayerView: UIViewRepresentable {
    var videoURL: URL

    init(videoURL: URL) {
        self.videoURL = videoURL
    }

    func makeUIView(context: Context) -> some UIView {
        return LoopingVideoPlayerUIView(url: videoURL)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

/// 비디오 재생을 반복하는 UIView
final class LoopingVideoPlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?


    init(url: URL) {
        let item = AVPlayerItem(url: url)

        super.init(frame: .zero)

        /// player 세팅
        let queuePlayer = AVQueuePlayer(playerItem: item)
        playerLayer.player = queuePlayer

        self.layer.addSublayer(playerLayer)

        /// 루프 생성
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)

        /// 루프 시작
        queuePlayer.play()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        playerLayer.frame = bounds
    }
}
