//
//  MyProfileTabType.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import Foundation

enum PeepTabType: Equatable, CaseIterable {
    case uploaded
    case myActivity

    var title: String {
        switch self {
        case .uploaded:
            return "나의 핍"
        case .myActivity:
            return "나의 활동"
        }
    }

    var selectedIcn: String {
        switch self {
        case .uploaded:
            return "IconPeepSelected"
        case .myActivity:
            return "IconStarSelected"
        }
    }

    var notSelectedIcn: String {
        switch self {
        case .uploaded:
            return "IconPeepNotSelected"
        case .myActivity:
            return "IconStarNotSelected"
        }
    }
}
