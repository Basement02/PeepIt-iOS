//
//  LoopingVideoPlayerView.swift
//  PeepIt
//
//  Created by 김민 on 1/6/25.
//

import AVFoundation
import Combine
import UIKit
import SwiftUI

struct LoopingVideoPlayerView: UIViewRepresentable {
    var videoURL: URL
    var isSoundOn: Bool
    var isPlaying: Bool
    @Binding var isReadyToPlay: Bool

    func makeUIView(context: Context) -> LoopingVideoPlayerUIView {
        return LoopingVideoPlayerUIView(url: videoURL, isSoundOn: isSoundOn, isReadyToPlay: $isReadyToPlay)
    }

    func updateUIView(_ uiView: LoopingVideoPlayerUIView, context: Context) {
        uiView.toggleSound(isSoundOn: isSoundOn)

        if isPlaying {
            uiView.playVideo()
        } else {
            uiView.pauseVideo()
        }
    }
}

/// 비디오 재생을 반복하는 UIView
final class LoopingVideoPlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    private var playerItem: AVPlayerItem?

    private var statusCancellable: AnyCancellable?
    private var isReadyToPlayBinding: Binding<Bool>

    init(url: URL, isSoundOn: Bool, isReadyToPlay: Binding<Bool>) {
        self.isReadyToPlayBinding = isReadyToPlay
        let item = AVPlayerItem(url: url)
        self.playerItem = item

        super.init(frame: .zero)

        let player = AVQueuePlayer(playerItem: item)
        player.volume = isSoundOn ? 1.0 : 0.0
        self.queuePlayer = player
        self.playerLayer.player = player
        self.layer.addSublayer(playerLayer)

        self.playerLooper = AVPlayerLooper(player: player, templateItem: item)

        statusCancellable = item
            .publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.isReadyToPlayBinding.wrappedValue = true
                }
            }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    func toggleSound(isSoundOn: Bool) {
        queuePlayer?.volume = isSoundOn ? 1.0 : 0.0
    }

    func playVideo() {
        queuePlayer?.play()
    }

    func pauseVideo() {
        queuePlayer?.pause()
    }
}
