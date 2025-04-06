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

struct KeychainHelper {

    func save(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func load(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8)
        else { return nil }

        return value
    }

    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

struct KeychainClient {
    var save: (String, String) -> Bool
    var load: (String) -> String?
    var delete: (String) -> Bool
}

extension DependencyValues {
    var keychain: KeychainClient {
        get { self[KeychainClient.self] }
        set { self[KeychainClient.self] = newValue }
    }
}

extension KeychainClient: DependencyKey {
    static let liveValue = KeychainClient(
        save: { value, key in
            KeychainHelper().save(value, forKey: key)
        },
        load: { key in
            KeychainHelper().load(forKey: key)
        },
        delete: { key in
            KeychainHelper().delete(forKey: key)
        }
    )
}
