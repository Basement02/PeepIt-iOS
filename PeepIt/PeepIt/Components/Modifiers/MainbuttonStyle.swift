//
//  MainbuttonStyle.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI

struct MainbuttonStyle: ViewModifier {
    var isEnabled: Bool
    var width: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: 55)
            .pretendard(.foodnote)
            .foregroundStyle(isEnabled ? Color.gray800 : Color.white)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(isEnabled ? Color.coreLime : Color.gray900)
            )
    }
}

extension View {
    
    func mainbuttonStyle(_ isEnabled: Bool, _ width: CGFloat = 250) -> some View {
        self.modifier(
            MainbuttonStyle(isEnabled: isEnabled, width: width)
        )
    }
}
