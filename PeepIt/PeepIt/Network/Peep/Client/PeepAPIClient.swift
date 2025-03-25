//
//  PeepAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation
import ComposableArchitecture

struct PeepAPIClient {
    var fetchPeepDetail: (Int) async throws -> CommonPeepDto
}

extension PeepAPIClient: DependencyKey {

    static let liveValue: PeepAPIClient = PeepAPIClient(
        fetchPeepDetail: { peepId in
            let requestDto = PeepDetailRequestDto(peepId: peepId)
            let requestAPI = PeepAPI.getPeepDetail(requestDto)
            return try await APIFetcher.shared.fetch(of: requestAPI)
        }
    )
}

extension DependencyValues {

    var peepAPIClient: PeepAPIClient {
        get { self[PeepAPIClient.self] }
        set { self[PeepAPIClient.self] = newValue }
    }
}
