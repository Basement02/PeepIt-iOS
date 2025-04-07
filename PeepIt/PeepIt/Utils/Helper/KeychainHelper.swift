//
//  KeychainHelper.swift
//  PeepIt
//
//  Created by 김민 on 4/7/25.
//

import Foundation
import Security
import ComposableArchitecture

enum TokenType: String {
    case register = "register"
    case access = "access"
    case refresh = "refresh"
}

struct KeychainClient {
    var save: (_ key: String, _ value: String) -> Bool
    var load: (_ key: String) -> String?
    var delete: (_ key: String) -> Bool
}

extension KeychainClient {
    
    static let live = KeychainClient(
        save: { key, value in
            guard let data = value.data(using: .utf8) else {
                return false
            }

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]

            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            return status == errSecSuccess
        },

        load: { key in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            guard status == errSecSuccess, let data = result as? Data else { return nil }
            return String(data: data, encoding: .utf8)
        },

        delete: { key in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]
            let status = SecItemDelete(query as CFDictionary)
            return status == errSecSuccess || status == errSecItemNotFound
        }
    )
}

extension DependencyValues {

    var keychain: KeychainClient {
        get { self[KeychainClient.self] }
        set { self[KeychainClient.self] = newValue }
    }
}

extension KeychainClient: DependencyKey {

    static let liveValue = KeychainClient.live
}
