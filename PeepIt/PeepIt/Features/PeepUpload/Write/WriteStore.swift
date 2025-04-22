//
//  WriteStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct WriteStore {

    @ObservableState
    struct State: Equatable {
        /// 전달된 편집 이미지
        var image: UIImage? = nil
        /// 전달된 편집 영상
        var videoURL: URL? = nil
        /// 본문
        var bodyText = ""
        /// 본문 입력 모드
        var isBodyInputMode = false
        /// 지도 모달 offset
        var modalOffset = Constant.screenHeight
        /// 키보드 관리
        var keyboardHeight = CGFloat(0)
        /// 현재 위치
        var currentLoc = Coordinate(x: 0, y: 0)
        /// 상단에 표시될 위치
        var location = ""
        /// 현재 동네  법정동 코드
        var bCode: String?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dismissButtonTapped
        case uploadButtonTapped
        case bodyTextEditorTapped
        case doneButtonTapped
        case addressTapped
        case viewTapped
        case modalDragOnChanged(height: CGFloat)
        case closeModal
        case closeUploadFeature

        /// 핍 업로드 api
        case uploadPeep
        case fetchPeepUploadResponse(Result<Void, Error>)

        /// 좌표 -> 주소
        case getAddressFromCoord(coord: Coordinate)
        case fetchAddressResult(Result<CurrentLocationInfo, Error>)

        /// 저장된 개인 법정동 정보 가져오기
        case getBCode
        case setBCode(bCode: String)
    }

    @Dependency(\.userProfileStorage) var userProfileStorage
    @Dependency(\.peepAPIClient) var peepAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.currentLoc):
                let loc = state.currentLoc

                return .merge(
                    .send(.getBCode),
                    .send(.getAddressFromCoord(coord: loc))
                )

            case .binding(\.bodyText):
                return .none

            case .dismissButtonTapped:
                return .run { _ in await dismiss() }

            case .uploadButtonTapped:
                return .send(.uploadPeep)

            case .bodyTextEditorTapped:
                state.isBodyInputMode = true
                return .none

            case .doneButtonTapped:
                state.isBodyInputMode = false
                return .none

            case .addressTapped:
                state.modalOffset = 0
                return .none

            case .viewTapped:
                return .send(.closeModal)

            case let .modalDragOnChanged(value):
                state.modalOffset = value
                return .none

            case .closeModal:
                state.modalOffset = Constant.screenHeight
                return .none

            case .uploadPeep:
                var data: Data?
                var isVideo = false

                if let imageData = state.image?.jpegData(compressionQuality: 0.8) {
                    data = imageData
                    isVideo = false
                } else if let videoURL = state.videoURL {
                    do {
                        data = try Data(contentsOf: videoURL)
                        isVideo = true
                    } catch {
                        print("Failed to load video data: \(error)")
                    }
                }

                guard let data = data,
                        let bCode = state.bCode else { return .none }

                let peepObj: UploadPeep = .init(
                    bCode: bCode,
                    content: state.bodyText,
                    x: state.currentLoc.x,
                    y: state.currentLoc.y,
                    building: state.location,
                    data: data
                )

                let isVideoCpy = isVideo

                return .run { send in
                    await send(
                        .fetchPeepUploadResponse(
                            Result { try await peepAPIClient.uploadPeep(peepObj, isVideoCpy) }
                        )
                    )
                }

            case let .fetchPeepUploadResponse(result):
                switch result {
                case .success:
                    return .send(.closeUploadFeature)

                case let .failure(error):
                    print(error)
                    return .none
                }

            case .closeUploadFeature:
                return .none

            case let .getAddressFromCoord(coord):
                return .run { send in
                    await send(
                        .fetchAddressResult(
                            Result { try await peepAPIClient.fetchCurrentLocationInfo(coord) }
                        )
                    )
                }

            case let .fetchAddressResult(result):
                switch result {
                    
                case let .success(info):
                    let buildingName = !info.building.isEmpty ? info.building :
                        !info.roadName.isEmpty ? info.roadName : info.town

                    state.location = buildingName
                    
                case let .failure(error):
                    print(error)
                    print("실패")
                }
                return .none

            case .getBCode:
                return .run { send in
                    if let savedProfile = try? await userProfileStorage.load(),
                       let bCode = savedProfile.townInfo?.bCode {
                        await send(.setBCode(bCode: bCode))
                    }
                }

            case let .setBCode(bCode):
                state.bCode = bCode
                return .none

            default:
                return .none
            }
        }
    }
}
