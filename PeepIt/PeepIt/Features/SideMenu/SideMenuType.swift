//
//  SideMenuType.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

enum SideMenuType: CaseIterable, Hashable {
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

    func destinationState() -> RootStore.Path.State {
        switch self {
        case .townPeeps:
            return .townPeeps(TownPeepsStore.State())
        case .notification:
            return .announce(AnnounceStore.State())
        case .peepItNews:
            return .announce(AnnounceStore.State())
        }
    }
}
