//
//  ProfileModifyStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture
import _PhotosUI_SwiftUI

@Reducer
struct ProfileModifyStore {

    @ObservableState
    struct State: Equatable {
        /// 기존 아이디
        var id = ""

        /// 기존 닉네임
        var nickname = ""
        /// 닉네임 유효성 상태
        var nicknameEnterState = EnterState.base
        /// 닉네임 가이드 문구
        var nicknameMessage = " "

        /// 기존 성별
        var selectedGender: GenderType? = nil

        /// 프로필 이미지
        var profileImgStr: String? = nil
        /// PhotoPicker 변수
        var selectedPhotoItem: PhotosPickerItem? = nil
        
        /// 유저 프로필 정보
        var userProfile: UserProfile?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 나타날 때
        case onAppear
        /// 이전 버튼 탭
        case backButtonTapped
        /// 성별 수정 버튼 탭
        case genderSaveButtonTapped
        /// 닉네임 수정 버튼 탭
        case nicknameSaveButtonTapped
        /// 성별 선택 시
        case selectGender(GenderType)
        /// 뷰 닫기
        case dismiss
        /// 프로필 업데이트
        case updateProfile(profile: UserProfile)

        /// 프로필 이미지 수정 api
        case modifyMyProfileImg(data: Data)
        case fetchModifyMyProfileImgResponse(Result<String, Error>)

        // 프로필 수정 api
        case modifyNickname(newName: String)
        case modifyGender(newGender: GenderType)
        case fetchModifyProfileResponse(Result<UserProfile, Error>)
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.userProfileStorage) var userProfileStorage
    @Dependency(\.authAPIClient) var authAPIClient
    @Dependency(\.memberAPIClient) var memberAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.nickname):
                let validState = validateNickname(state.nickname)
                state.nicknameEnterState = validState.enterState
                state.nicknameMessage = validState.message

                return .none

            case .binding(\.selectedPhotoItem):
                guard let photoItem = state.selectedPhotoItem else { return .none }

                return .run { send in
                    if let data = try? await photoItem.loadTransferable(type: Data.self) {
                        await send(.modifyMyProfileImg(data: data))
                    }
                }

            case .onAppear:
                return .run { send in
                    if let savedProfile = try? await userProfileStorage.load() {
                        await send(.updateProfile(profile: savedProfile))
                    }
                }

            case .backButtonTapped:
                return .send(.dismiss)

            case let .selectGender(type):
                if type == state.selectedGender {
                    state.selectedGender = nil
                } else {
                    state.selectedGender = type
                }

                return .none

            case .genderSaveButtonTapped:
                guard let newGender = state.selectedGender else { return .none }
                return .send(.modifyGender(newGender: newGender))

            case .nicknameSaveButtonTapped:
                let newNickname = state.nickname
                return .send(.modifyNickname(newName: newNickname))

            case .dismiss:
                return .run { _ in await self.dismiss() }

            case let .updateProfile(profile):
                state.userProfile = profile
                state.profileImgStr = profile.profile
                state.nickname = profile.name
                state.id = profile.id
                state.selectedGender = profile.gender

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
                    state.profileImgStr = value
                    state.userProfile?.profile = value

                    let newProfile = state.userProfile

                    return .run { _ in
                        if let newProfile = newProfile {
                            try await userProfileStorage.save(newProfile)
                        }
                    }

                case let .failure(error):
                    // TODO: 오류
                    print(error)
                }

                return .none

            case let .modifyNickname(nickname):
                var newProfile = state.userProfile
                newProfile?.name = nickname
                guard let profile = newProfile else { return .none }

                return .run { send in
                    await send(
                        .fetchModifyProfileResponse(
                            Result { try await memberAPIClient.modifyUserProfile(profile) }
                        )
                    )
                }

            case let .modifyGender(newGender):
                var newProfile = state.userProfile
                newProfile?.gender = newGender
                guard let profile = newProfile else { return .none }

                return .run { send in
                    await send(
                        .fetchModifyProfileResponse(
                            Result { try await memberAPIClient.modifyUserProfile(profile) }
                        )
                    )
                }

            case let .fetchModifyProfileResponse(result):
                switch result {

                case let .success(value):
                    return .run { send in
                        try await userProfileStorage.save(value)
                        await send(.dismiss)
                    }

                case .failure:
                    // TODO: 에러 처리
                    return .none
                }

            default:
                return .none
            }
        }
    }

    func validateNickname(_ nickname: String) -> NicknameValidation {
        switch true {
        case nickname.isEmpty:
            return .base
        case !nickname.isValidForAllowedCharacters:
            return .wrongWord
        case nickname.count > 18:
            return .maxCount
        default:
            return .validated
        }
    }
}
