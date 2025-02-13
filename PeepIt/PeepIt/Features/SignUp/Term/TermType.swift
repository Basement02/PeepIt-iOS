//
//  TermType.swift
//  PeepIt
//
//  Created by 김민 on 10/6/24.
//

import Foundation

enum TermType: Hashable, CaseIterable {
    case service
    case location
    case privateInfo
    case marcketing

    var title: String {
        switch self {
        case .service:
            return "서비스 이용약관"
        case .location:
            return "위치기반 서비스 이용약관"
        case .privateInfo:
            return "개인정보 수집/이용 동의"
        case .marcketing:
            return "마케팅∙홍보 목적의 수집∙이용 동의"
        }
    }

    var isEssential: Bool {
        switch self {
        case .service, .location, .privateInfo:
            return true
        case .marcketing:
            return false
        }
    }
}
