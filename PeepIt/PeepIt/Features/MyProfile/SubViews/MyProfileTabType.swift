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
            return "업로드한 핍"
        case .myActivity:
            return "내 활동"
        }
    }
}
