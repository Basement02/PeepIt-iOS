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
    ///   - isSoundOn: 영상 소리 모드
    /// - Returns: 스티커가 추가된 동영상의 URL
    func renderVideo(
        fromVideoAt videoURL: URL,
        stickers: [StickerItem],
        texts: [TextItem],
        isSoundOn: Bool
    ) async throws -> URL

}

final class VideoRenderService: VideoRenderServiceProtocol {

    func renderVideo(
        fromVideoAt videoURL: URL,
        stickers: [StickerItem],
        texts: [TextItem],
        isSoundOn: Bool
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

        compositionTrack.preferredTransform = try await assetTrack.load(.preferredTransform)

        if isSoundOn {
            if let audioTrack = try await asset.loadTracks(withMediaType: .audio).first {
                guard let compositionAudioTrack = composition.addMutableTrack(
                    withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid
                ) else {
                    throw NSError(
                        domain: "VideoEditorError",
                        code: 3,
                        userInfo: [NSLocalizedDescriptionKey: "Unable to add audio track."]
                    )
                }

                do {
                    let timeRange = CMTimeRange(start: .zero, duration: try await asset.load(.duration))
                    try compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: .zero)
                } catch {
                    throw NSError(
                        domain: "VideoEditorError",
                        code: 4,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to insert audio track: \(error.localizedDescription)"]
                    )
                }
            } else {
                print("No audio track found, exporting video without audio.")
            }
        }


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

        add(stickers: stickers, texts: texts, to: overlayLayer, videoSize: videoSize)

        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)

        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)

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

    private func add(
        stickers: [StickerItem],
        texts: [TextItem],
        to layer: CALayer,
        videoSize: CGSize
    ) {
        for sticker in stickers {
            addSticker(sticker: sticker, to: layer, videoSize: videoSize)
        }

        for text in texts {
            addText(text: text, to: layer, videoSize: videoSize)
        }
    }

    private func addSticker(
        sticker: StickerItem,
        to layer: CALayer,
        videoSize: CGSize
    ) {
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

    private func addText(
        text: TextItem,
        to layer: CALayer,
        videoSize: CGSize
    ) {
        let adjustedFontSize = text.scale * videoSize.height / (Constant.screenWidth * (16 / 9))

        let attributedText = NSAttributedString(
            string: text.text,
            attributes: [
                .font: UIFont.systemFont(ofSize: adjustedFontSize, weight: .bold),
                .foregroundColor: UIColor(text.color)
            ]
        )

        // (1) 텍스트의 크기 계산
        let textSize = attributedText.boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size

        // (2) 포지션 변환
        let xRatio = videoSize.width / Constant.screenWidth
        let yRatio = videoSize.height / (Constant.screenWidth * (16/9))

        let videoX = xRatio * text.position.x
        let videoY = videoSize.height - yRatio * text.position.y

        // (3) CATextLayer 생성
        let textLayer = CATextLayer()
        textLayer.string = attributedText
        textLayer.alignmentMode = .center

        textLayer.frame = CGRect(
            x: videoX - textSize.width / 2,
            y: videoY - textSize.height / 2,
            width: textSize.width,
            height: textSize.height
        )

        // (4) 레이어에 추가
        layer.addSublayer(textLayer)
    }
}
