//
//  ScrollOffsetKey.swift
//  PeepIt
//
//  Created by 김민 on 2/11/25.
//

import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
