//
//  GenderType.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation

enum GenderType: CaseIterable, Hashable, Codable {
    case woman
    case man
    case notSelected

    var title: String {
        switch self {
        case .woman:
            return "여성"
        case .man:
            return "남성"
        case .notSelected:
            return "기타"
        }
    }

    var type: String {
        switch self {
        case .woman:
            return "female"
        case .man:
            return "male"
        case .notSelected:
            return "other"
        }
    }
}
