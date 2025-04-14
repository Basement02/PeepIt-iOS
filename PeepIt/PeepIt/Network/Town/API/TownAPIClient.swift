//
//  TownAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation
import ComposableArchitecture

struct TownAPIClient {
    var getTownLegalCode: (Coordinate) async throws -> LegalCode?
}

extension TownAPIClient: DependencyKey {

    static let liveValue: TownAPIClient = TownAPIClient(
        getTownLegalCode: { coord in
            let requestDto: LegalCodeRequestDto = .init(x: "\(coord.x)", y: "\(coord.y)")
            let requestAPI: TownAPI = .getLegalCode(requestDto)
            let response: LegalCodeResponseDto = try await APIFetcher.shared.openAPIFetcher(of: requestAPI)
            return response.toLegalCode()
        }
    )
}

extension DependencyValues {

    var townAPIClient: TownAPIClient {
        get { self[TownAPIClient.self] }
        set { self[TownAPIClient.self] = newValue }
    }
}
