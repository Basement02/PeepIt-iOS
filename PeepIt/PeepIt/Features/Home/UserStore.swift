//
//  UserStore.swift
//  PeepIt
//
//  Created by 김민 on 5/2/25.
//

import ComposableArchitecture
import UIKit

@Reducer
struct UserStore {

    @ObservableState
    struct State: Equatable {
        /// 사용자 프로필 정보
        var userProfile: UserProfile?
        /// 사용자가 인증한 동네의 법정동 코드
        var userBCode: String?
    }

    enum Action {
        /// 내 프로필 조회 api
        case getMyProfile
        case updateMyProfile(profile: UserProfile)

        /// 업데이트 끝
        case didFinishLoadProfile
    }

    @Dependency(\.userProfileStorage) var userProfileStorage

    var body: some Reducer<State, Action> {

        Reduce { state, action in
            switch action {

            case .getMyProfile:
                return .run { send in
                    if let storedProflie = try await userProfileStorage.load() {
                        await send(.updateMyProfile(profile: storedProflie))
                        await send(.didFinishLoadProfile)
                    }
                }

            case let .updateMyProfile(profile):
                state.userProfile = profile
                state.userBCode = profile.townInfo?.bCode
                
                return .none

            case .didFinishLoadProfile:
                return .none
            }
        }
    }
}
