//
//  MainLimeButtonStyle.swift
//  PeepIt
//
//  Created by 김민 on 11/15/24.
//

import SwiftUI

struct MainLimeButtonStyle: ViewModifier {
    var width: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: 55)
            .pretendard(.foodnote)
            .foregroundStyle(Color.gray800)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.coreLime)
            )
    }
}

extension View {

    func mainLimeButtonStyle(_ width: CGFloat = 250) -> some View {
        self.modifier(
            MainLimeButtonStyle(width: width)
        )
    }
}
