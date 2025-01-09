//
//  VideoRenderServiceKey.swift
//  PeepIt
//
//  Created by 김민 on 1/6/25.
//

import Dependencies

struct VideoRenderServiceKey: DependencyKey {
    static let liveValue: VideoRenderServiceProtocol = VideoRenderService()
}

extension DependencyValues {

    var videoRenderService: VideoRenderServiceProtocol {
        get { self[VideoRenderServiceKey.self] }
        set { self[VideoRenderServiceKey.self] = newValue }
    }
}
