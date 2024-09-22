//
//  ChatType.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import SwiftUI

enum ChatType {
    case mine
    case uploader
    case others

    var backgroundColor: Color {
        switch self {
        case .mine:
            return .yellow
        case .uploader:
            return .green
        case .others:
            return .blue
        }
    }
}
