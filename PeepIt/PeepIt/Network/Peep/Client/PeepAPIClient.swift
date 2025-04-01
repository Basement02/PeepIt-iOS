//
//  PeepAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation
import ComposableArchitecture

/// 핍 관련 API
struct PeepAPIClient {
    /// 사용자가 업로드한 핍 리스트 조회
    var fetchUploadedPeeps: (Int, Int) async throws -> PagedPeeps
    /// 사용자가 반응한 핍 리스트 조회
    var fetchReactedPeeps: (Int, Int) async throws -> PagedPeeps
    /// 사용자가 댓글 단 핍 리스트 조회
    var fetchChattedPeeps: (Int, Int) async throws -> PagedPeeps
    /// 사용자가 업로드한 실시간 핍 리스트 조회
    var fetchUserActivePeeps: (Int, Int) async throws -> PagedPeeps
}

extension PeepAPIClient: DependencyKey {

    static let liveValue: PeepAPIClient = PeepAPIClient(
        fetchUploadedPeeps: { page, size in
            let requestDto: PageRequestDto = .init(page: page, size: size)
            let requestAPI = PeepAPI.getMyUploadedPeeps(requestDto)
            let response: PagedResponsePeepDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        fetchReactedPeeps: { page, size in
            let requestDto: PageRequestDto = .init(page: page, size: size)
            let requestAPI = PeepAPI.getReactedPeeps(requestDto)
            let response: PagedResponsePeepDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        fetchChattedPeeps: { page, size in
            let requestDto: PageRequestDto = .init(page: page, size: size)
            let requestAPI = PeepAPI.getChattedPeeps(requestDto)
            let response: PagedResponsePeepDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        fetchUserActivePeeps: { page, size in
            let requestDto: PageRequestDto = .init(page: page, size: size)
            let requestAPI = PeepAPI.getActivePeeps(requestDto)
            let response: PagedResponsePeepDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        }
    )
}

extension DependencyValues {

    var peepAPIClient: PeepAPIClient {
        get { self[PeepAPIClient.self] }
        set { self[PeepAPIClient.self] = newValue }
    }
}
