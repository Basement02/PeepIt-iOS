//
//  UserProfileStorageClient.swift
//  PeepIt
//
//  Created by 김민 on 4/15/25.
//

import Foundation
import ComposableArchitecture
import Dependencies

struct UserProfileStorageClient {
    var save: (UserProfile) async throws -> Void
    var load: () async throws -> UserProfile?
    var clear: () async throws -> Void
}

extension UserProfileStorageClient {
    static let live = UserProfileStorageClient(
        save: { profile in
            let data = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(data, forKey: "user_profile")
        },
        load: {
            guard let data = UserDefaults.standard.data(forKey: "user_profile") else { return nil }
            return try JSONDecoder().decode(UserProfile.self, from: data)
        },
        clear: {
            UserDefaults.standard.removeObject(forKey: "user_profile")
        }
    )
}

extension DependencyValues {
    var userProfileStorage: UserProfileStorageClient {
        get { self[UserProfileStorageKey.self] }
        set { self[UserProfileStorageKey.self] = newValue }
    }
}

private enum UserProfileStorageKey: DependencyKey {
    static let liveValue: UserProfileStorageClient = .live
}
