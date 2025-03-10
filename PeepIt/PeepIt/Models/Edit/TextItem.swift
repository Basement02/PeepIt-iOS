//
//  TextItem.swift
//  PeepIt
//
//  Created by 김민 on 10/15/24.
//

import SwiftUI

struct TextItem: Identifiable, Equatable {
    var id = UUID()
    var text = ""
    var position: CGPoint = .zero
    var fontSize: CGFloat = 24.0
    var color: Color = .white
    var textHeight: CGFloat = 0
    var scale: CGFloat = 1.0
}
