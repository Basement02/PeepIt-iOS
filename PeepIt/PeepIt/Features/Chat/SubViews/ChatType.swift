//
//  ChatType.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import SwiftUI

enum ChatType: Equatable, Hashable {
    case mine
    case uploader
    case others

    var backgroundColor: Color {
        switch self {
        case .mine:
            return Color.base
        case .others:
            return Color.elevated
        case .uploader:
            return Color.coreLimeDOp
        }
    }
}

extension View {

    func makeCorner(of chatType: ChatType) -> some View {
        switch chatType {

        case .mine:
            return AnyView(
                self
                    .roundedCorner(13.2, corners: .topLeft)
                    .roundedCorner(13.2, corners: .bottomLeft)
                    .roundedCorner(17.6, corners: .bottomRight)
            )

        case .uploader, .others:
            return AnyView(
                self
                    .roundedCorner(13.2, corners: .topRight)
                    .roundedCorner(13.2, corners: .bottomRight)
                    .roundedCorner(17.6, corners: .bottomLeft)
            )
        }
    }
}
