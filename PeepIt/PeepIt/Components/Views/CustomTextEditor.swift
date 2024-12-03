//
//  CustomTextEditor.swift
//  PeepIt
//
//  Created by 김민 on 12/3/24.
//

import SwiftUI

struct CustomTextEditor: View {

    @Binding var text: String
    @State private var placeholder: String

    init(placeholder: String, text: Binding<String>) {
        _text = text
        _placeholder = State(initialValue: placeholder)
    }

    var body: some View {
        ZStack {
            TextEditor(text: $placeholder)
                .foregroundStyle(Color.gray300)
                .disabled(true)
                .scrollContentBackground(.hidden)
                .background(Color.clear)

            TextEditor(text: $text)
                .opacity(text == "" ? 0 : 1)
                .foregroundStyle(Color.white)
                .tint(Color.coreLime)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .pretendard(.body05)
        .padding(.all, 12)
        .background(Color.gray700)
        .roundedCorner(16, corners: .allCorners)
    }
}
