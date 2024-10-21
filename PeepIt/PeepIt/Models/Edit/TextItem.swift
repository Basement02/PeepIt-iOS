//
//  TextItem.swift
//  PeepIt
//
//  Created by 김민 on 10/15/24.
//

import Foundation

struct TextItem: Identifiable, Equatable {
    var id = UUID()
    var text = ""
    var position: CGPoint = .zero
    var scale: CGFloat = 1.0
}
