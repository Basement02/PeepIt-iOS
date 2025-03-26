//
//  Encodable+Extension.swift
//  PeepIt
//
//  Created by 김민 on 3/25/25.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
