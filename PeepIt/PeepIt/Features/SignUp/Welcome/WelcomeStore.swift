//
//  WelcomeStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

@Reducer
struct WelcomeStore {

    @ObservableState
    struct State: Equatable {
        /// PhotoPicker 변수
        var selectedPhotoItem: PhotosPickerItem? = nil
        /// 유저 프로필
        var myProfile: UserProfile?
        /// 인증 여부
        var isAuthorized: Bool = true
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 뷰 등장
        case onAppear
        /// 홈으로 버튼 탭
        case goToHomeButtonTapped

        /// 내 프로필 조회 api
        case getMyProfile
        case fetchGetMyProfileResponse(Result<UserProfile, Error>)

        /// 프로필 이미지 수정 api
        case modifyMyProfileImg(data: Data)
        case fetchModifyMyProfileImgResponse(Result<String, Error>)
    }

    @Dependency(\.memberAPIClient) var memberAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.selectedPhotoItem):
                guard let photoItem = state.selectedPhotoItem else { return .none }
                
                return .run { send in
                    if let data = try? await photoItem.loadTransferable(type: Data.self) {
                        await send(.modifyMyProfileImg(data: data))
                    }
                }

            case .onAppear:
                return .send(.getMyProfile)

            case .goToHomeButtonTapped:
                return .none

            case .getMyProfile:
                return .run { send in
                    await send(
                        .fetchGetMyProfileResponse(
                            Result { try await memberAPIClient.getMemberDetail() }
                        )
                    )
                }

            case let .fetchGetMyProfileResponse(result):
                switch result {
                case let .success(profile):
                    state.myProfile = profile
                    state.isAuthorized = profile.isCertificated

                case .failure:
                    // TODO: 오류 처리
                    print("오류")
                }

                return .none

            case let .modifyMyProfileImg(data):
                return .run { send in
                    await send(
                        .fetchModifyMyProfileImgResponse(
                            Result { try await memberAPIClient.modifyUserProfileImage(data) }
                        )
                    )
                }


            case let .fetchModifyMyProfileImgResponse(result):
                switch result {

                case let .success(value):
                    state.myProfile?.profile = value

                case let .failure(error):
                    // TODO: 오류
                    print(error)
                }

                return .none

            default:
                return .none
            }
        }
    }
}
