//
//  URL+Extension.swift
//  PeepIt
//
//  Created by 김민 on 4/22/25.
//

import AVFoundation
import UIKit

extension URL {

    var isVideo: Bool {
        let videoExtensions = ["mp4", "mov", "avi", "m4v"]
        return videoExtensions.contains(self.pathExtension.lowercased())
    }

    /// 비디오 썸네일 생성
    func generateVideoThumbnail(
        at seconds: TimeInterval = 1.0,
        completion: @escaping (UIImage?
        ) -> Void) {
        guard isVideo else {
            completion(nil)
            return
        }

        let asset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        DispatchQueue.global().async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                print("Thumbnail generation failed: \(error)")

                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func loadThumbnail(completion: @escaping (UIImage?) -> Void) {
        if isVideo {
            generateVideoThumbnail(completion: completion)
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: self),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}
