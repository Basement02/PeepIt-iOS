//
//  StickerItem.swift
//  PeepIt
//
//  Created by 김민 on 10/15/24.
//

import SwiftUI

struct StickerItem: Identifiable, Equatable {
    var id = UUID()
    var stickerName = ""
    var position: CGPoint = .zero
    var scale: CGFloat = 1.0
}
