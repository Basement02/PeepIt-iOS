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
    /// 동네 핍 리스트 조회(최신순)
    var fetchTownPeeps: (Int, Int) async throws -> PagedPeeps
    /// 핍 업로드
    var uploadPeep: (UploadPeep, Bool) async throws -> Void
    /// 좌표 -> 주소
    var fetchCurrentLocationInfo: (Coordinate) async throws -> CurrentLocationInfo
    /// 지도 내 핍 조회
    var fetchPeepsInMap: (Coordinate, Int, Int, Int) async throws -> PagedPeeps
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
        },
        fetchTownPeeps: { page, size in
            let requestDto: PageRequestDto = .init(page: page, size: size)
            let requestAPI = PeepAPI.getRecentTownPeeps(requestDto)
            let response: PagedResponsePeepDto = try await APIFetcher.shared.fetch(of: requestAPI)
            return response.toModel()
        },
        uploadPeep: { uploadPeep, isVideo in
            let requestDto: PeepUploadRequestDto = .init(
                legalDistrictCode: uploadPeep.bCode,
                content: uploadPeep.content,
                latitude: uploadPeep.y,
                longitude: uploadPeep.x,
                building: uploadPeep.building
            )

            let requestAPI = PeepAPI.postPeep(requestDto, uploadPeep.data, isVideo)
            let response: CommonPeepDto = try await APIFetcher.shared.fetch(of: requestAPI)
        },
        fetchCurrentLocationInfo: { coord in
            let requestDto: CurrentAddressRequestDto = .init(x: "\(coord.x)", y: "\(coord.y)")
            let requestAPI = PeepAPI.getCurrentLocationInfo(requestDto)
            let response: CurrentAddressResponseDto = try await APIFetcher.shared.openAPIFetcher(of: requestAPI)
            return response.toLocationInfo()
        },
        fetchPeepsInMap: { coord, dist, page, size in
            let requestDto: MapPeepRequestDto = .init(
                longitude: coord.x,
                latitude: coord.y,
                dist: dist,
                page: page,
                size: size
            )
            let requestAPI = PeepAPI.getMapPeeps(requestDto)
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
