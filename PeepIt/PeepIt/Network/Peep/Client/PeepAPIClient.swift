//
//  PeepAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation
import ComposableArchitecture

struct PeepAPIClient {
    var fetchUploadedPeeps: (Int, Int) async throws -> [Peep]
    var fetchTownPeeps: (Int, Int) async throws -> [Peep]
}

extension PeepAPIClient: DependencyKey {

    static let liveValue: PeepAPIClient = PeepAPIClient(
        fetchUploadedPeeps: { page, size in
            let requestDto: PageRequestDto = .init(page: page, size: size)
            let requestAPI = PeepAPI.getMyUploadedPeeps(requestDto)
            let response: PagedResponsePeepDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        fetchTownPeeps: { page, size in
            let requestDto: PageRequestDto = .init(page: page, size: size)
            let requestAPI = PeepAPI.getRecentTownPeeps(requestDto)
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
