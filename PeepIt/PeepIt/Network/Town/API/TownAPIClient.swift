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
    var modifyUserTown: (String) async throws -> Void
}

extension TownAPIClient: DependencyKey {

    static let liveValue: TownAPIClient = TownAPIClient(
        getTownLegalCode: { coord in
            let requestDto: LegalCodeRequestDto = .init(x: "\(coord.x)", y: "\(coord.y)")
            let requestAPI: TownAPI = .getLegalCode(requestDto)
            let response: LegalCodeResponseDto = try await APIFetcher.shared.openAPIFetcher(of: requestAPI)
            return response.toLegalCode()
        },
        modifyUserTown: { code in
            let requestDto: ModifyTownRequestDto = .init(legalDistrictCode: code)
            let requestAPI: TownAPI = .patchUserTown(requestDto)
            let response: EmptyDecodable = try await APIFetcher.shared.fetch(of: requestAPI)
        }
    )
}

extension DependencyValues {

    var townAPIClient: TownAPIClient {
        get { self[TownAPIClient.self] }
        set { self[TownAPIClient.self] = newValue }
    }
}
