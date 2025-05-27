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
        @Shared(.fileStorage(.documentsDirectory.appending(component: "user.json")))
        var user: UserProfile?
    }

    enum Action {
        /// 내 프로필 기기 정보에서 받아오기
        case getMyProfile
        ///  내 프로필 기기 정보에 저장
        case saveMyProfile(profile: UserProfile)

        /// 내 프로필 조회 api
        case getMyProfileFromServer
        case fetchProfileResponse(Result<UserProfile, Error>)

        /// 프로필 업데이트
        case updateMyProfile(profile: UserProfile)

        /// 업데이트 끝
        case didFinishLoadProfile
    }

    @Dependency(\.userProfileStorage) var userProfileStorage
    @Dependency(\.memberAPIClient) var memberAPIClient

    var body: some Reducer<State, Action> {

        Reduce { state, action in
            switch action {

            case .getMyProfile:
                return .run { send in
                    if let storedProflie = try await userProfileStorage.load() {
                        await send(.updateMyProfile(profile: storedProflie))
                    }
                }

            case let .saveMyProfile(profile):
                return .run { _ in
                    try await userProfileStorage.save(profile)
                }

            case .getMyProfileFromServer:
                return .run { send in
                    await send(
                        .fetchProfileResponse(
                            Result { try await memberAPIClient.getMemberDetail() }
                        )
                    )
                }

            case let .fetchProfileResponse(result):
                switch result {
                case let .success(profile):
                    return .concatenate(
                        .run { send in
                            await send(.saveMyProfile(profile: profile))
                        },
                        .run { send in
                            await send(.updateMyProfile(profile: profile))
                        }
                    )

                case .failure:
                    // TODO: 에러메세지 띄우기
                    return .none
                }

            case let .updateMyProfile(profile):
                state.user = profile

                return .send(.didFinishLoadProfile)

            case .didFinishLoadProfile:
                return .none
            }
        }
    }
}
