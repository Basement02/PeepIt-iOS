//
//  VideoRenderService.swift
//  PeepIt
//
//  Created by 김민 on 1/6/25.
//

import AVFoundation
import UIKit
import SwiftUICore

protocol VideoRenderServiceProtocol {
    /// 동영상에 스티커를 추가하는 메서드
       /// - Parameters:
       ///   - videoURL: 원본 동영상 URL
       ///   - stickers: 추가할 스티커 리스트
       /// - Returns: 스티커가 추가된 동영상의 URL
       func renderVideo(
        fromVideoAt videoURL: URL,
        stickers: [StickerItem]
       ) async throws -> URL
}

final class VideoRenderService: VideoRenderServiceProtocol {

    func renderVideo(
        fromVideoAt videoURL: URL,
        stickers: [StickerItem]
    ) async throws -> URL {
        let asset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()

        guard
            let compositionTrack = composition.addMutableTrack(
                withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
            let assetTrack = try await asset.loadTracks(withMediaType: .video).first
        else {
            throw NSError(
                domain: "VideoEditorError",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unable to load video track."]
            )
        }

        do {
            let timeRange = CMTimeRange(start: .zero, duration: try await asset.load(.duration))
            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
        } catch {
            throw NSError(
                domain: "VideoEditorError",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Failed to insert video track: \(error.localizedDescription)"]
            )
        }

        // Apply preferredTransform
        compositionTrack.preferredTransform = try await assetTrack.load(.preferredTransform)


        let transform = try await assetTrack.load(.preferredTransform)
        let naturalSize = try await assetTrack.load(.naturalSize)

        let videoSize: CGSize
        if transform.a == 0
            && abs(transform.b) == 1
            && abs(transform.c) == 1
            && transform.d == 0 {
            videoSize = CGSize(width: naturalSize.height, height: naturalSize.width)
        } else {
            videoSize = naturalSize
        }

        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)

        // Add stickers to overlay layer
        add(stickers: stickers, to: overlayLayer, videoSize: videoSize)

        // Video Layer
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)

        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)

        // Video Composition
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
            postProcessingAsVideoLayer: videoLayer,
            in: outputLayer
        )

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)

        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionTrack)
        layerInstruction.setTransform(try await assetTrack.load(.preferredTransform), at: .zero)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]

        // Export
        guard let export = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality
        ) else {
            throw NSError(
                domain: "VideoEditorError",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Unable to create export session."]
            )
        }

        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID()).mp4")

        export.videoComposition = videoComposition
        export.outputFileType = .mp4
        export.outputURL = outputURL

        return try await withCheckedThrowingContinuation { continuation in
            export.exportAsynchronously {
                switch export.status {
                case .completed:
                    continuation.resume(returning: outputURL)
                case .failed, .cancelled:
                    continuation.resume(
                        throwing: export.error ?? NSError(
                            domain: "VideoEditorError",
                            code: 4,
                            userInfo: [NSLocalizedDescriptionKey: "Export failed."])
                    )
                default:
                    continuation.resume(
                        throwing: NSError(
                            domain: "VideoEditorError",
                            code: 5,
                            userInfo: [NSLocalizedDescriptionKey: "Unknown export error."])
                    )
                }
            }
        }
    }
    

    private func add(stickers: [StickerItem], to layer: CALayer, videoSize: CGSize) {
        for sticker in stickers {
            add(sticker: sticker, to: layer, videoSize: videoSize)
        }
    }

    private func add(sticker: StickerItem, to layer: CALayer, videoSize: CGSize) {
        guard let stickerImage = UIImage(named: sticker.stickerName)?.cgImage else { return }

        // (1) 포지션 변환
        let xRatio = videoSize.width / Constant.screenWidth
        let yRatio = videoSize.height / (Constant.screenWidth * (16/9))

        let videoX = xRatio * sticker.position.x
        let videoY = videoSize.height - yRatio * sticker.position.y

        // (2) 스티커 크기 변환
        let stickerSize = 120 * sticker.scale * xRatio

        // (3) CALayer 생성 및 적용
        let stickerLayer = CALayer()
        stickerLayer.contents = stickerImage

        stickerLayer.frame = CGRect(
            x: videoX - (stickerSize/2),
            y: videoY - (stickerSize/2),
            width: stickerSize,
            height: stickerSize
        )

        layer.addSublayer(stickerLayer)
    }
}
