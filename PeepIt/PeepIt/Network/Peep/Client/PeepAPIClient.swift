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
    var fetchUploadedPeeps: (Int, Int) async throws -> PagedPeeps
    var fetchReactedPeeps: (Int, Int) async throws -> PagedPeeps
    var fetchChattedPeeps: (Int, Int) async throws -> PagedPeeps
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
