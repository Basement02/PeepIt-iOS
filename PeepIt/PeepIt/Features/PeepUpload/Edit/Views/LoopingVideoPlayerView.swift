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
    var isSoundOn: Bool

    func makeUIView(context: Context) -> LoopingVideoPlayerUIView {
        LoopingVideoPlayerUIView(url: videoURL, isSoundOn: isSoundOn)
    }

    func updateUIView(_ uiView: LoopingVideoPlayerUIView, context: Context) {
        uiView.toggleSound(isSoundOn: isSoundOn) 
    }
}

/// 비디오 재생을 반복하는 UIView
final class LoopingVideoPlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?

    init(url: URL, isSoundOn: Bool) {
        let item = AVPlayerItem(url: url)

        super.init(frame: .zero)

        /// player 세팅
        let player = AVQueuePlayer(playerItem: item)
        player.volume = isSoundOn ? 1.0 : 0.0
        self.queuePlayer = player

        playerLayer.player = player

        self.layer.addSublayer(playerLayer)

        /// 루프 생성
        playerLooper = AVPlayerLooper(player: player, templateItem: item)

        /// 루프 시작
        player.play()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggleSound(isSoundOn: Bool) {
        queuePlayer?.volume = isSoundOn ? 1.0 : 0.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        playerLayer.frame = bounds
    }
}
