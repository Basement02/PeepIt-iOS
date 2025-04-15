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
        /// 기존 성별
        var selectedGender: GenderType? = nil
        /// 닉네임 유효성 검증 상태
        var nicknameValidation = NicknameValidation.base
        /// 입력창 히위 뷰 State
        var enterFieldState = CheckEnterFieldStore.State()
        /// 프로필
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
        /// 저장 버튼 탭
        case saveButtonTapped
        /// 성별 선택 시
        case selectGender(GenderType)
        /// 뷰 닫기
        case dismiss
        /// 하위뷰 액션 연결
        case enterFieldAction(CheckEnterFieldStore.Action)
        /// 프로필 업데이트
        case updateProfile(profile: UserProfile)

        /// 프로필 이미지 수정 api
        case modifyMyProfileImg(data: Data)
        case fetchModifyMyProfileImgResponse(Result<String, Error>)

        // 프로필 수정 api
        case modifyGender(newGender: GenderType)
        case fetchModifyProfileResponse(Result<UserProfile, Error>)
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.userProfileStorage) var userProfileStorage
    @Dependency(\.memberAPIClient) var memberAPIClient

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(
            state: \.enterFieldState,
            action: \.enterFieldAction
        ) {
            CheckEnterFieldStore()
        }

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
                state.enterFieldState.fieldType = .nickname
                state.enterFieldState.text = state.nickname

                return .run { send in
                    if let savedProfile = try? await userProfileStorage.load() {
                        await send(.updateProfile(profile: savedProfile))
                    }
                }

            case .enterFieldAction(.binding(\.text)):
                state.nicknameValidation = validateNickname(state.enterFieldState.text)
                state.enterFieldState.enterState = state.nicknameValidation.enterState
                state.enterFieldState.message = state.nicknameValidation.message

                return .none

            case .backButtonTapped:
                return .send(.dismiss)

            case let .selectGender(type):
                if type == state.selectedGender {
                    state.selectedGender = nil
                } else {
                    state.selectedGender = type
                }

                return .none

            case .saveButtonTapped:
                guard let newGender = state.selectedGender else { return .none }
                return .send(.modifyGender(newGender: newGender))

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
