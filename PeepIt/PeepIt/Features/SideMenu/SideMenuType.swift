//
//  SideMenuType.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation

enum SideMenuType: CaseIterable {
    case townPeeps
    case notification
    case peepItNews

    var title: String {
        switch self {
        case .townPeeps:
            return "동네 소식"
        case .notification:
            return "내 소식"
        case .peepItNews:
            return "서비스 소식"
        }
    }

    var iconImage: String {
        switch self {
        case .townPeeps:
            return ""
        case .notification:
            return ""
        case .peepItNews:
            return ""
        }
    }
}
