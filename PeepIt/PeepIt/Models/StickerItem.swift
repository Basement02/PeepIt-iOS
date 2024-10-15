//
//  StickerItem.swift
//  PeepIt
//
//  Created by 김민 on 10/15/24.
//

import Foundation

struct StickerItem: Identifiable, Equatable {
    var id = UUID()
    var stickerName = ""
    var position: CGPoint = .zero
}
