//
//  MainbuttonStyle.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI

struct MainGrayButtonStyle: ViewModifier {
    var width: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: 55)
            .pretendard(.foodnote)
            .foregroundStyle(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.gray900)
            )
    }
}

extension View {
    
    func mainGrayButtonStyle(_ width: CGFloat = 250) -> some View {
        self.modifier(
            MainGrayButtonStyle(width: width)
        )
    }
}
