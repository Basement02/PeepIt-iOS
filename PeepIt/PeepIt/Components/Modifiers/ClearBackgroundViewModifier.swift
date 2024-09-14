//
//  ClearBackgroundView.swift
//  PeepIt
//
//  Created by 김민 on 9/13/24.
//

import SwiftUI
import UIKit

struct ClearBackgroundView: UIViewRepresentable {

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()

        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

struct ClearBackgroundViewModifier: ViewModifier {

    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(.clear)
                .presentationBackgroundInteraction(.enabled)
        } else {
            content
                .background(ClearBackgroundView())
        }
    }
}

extension View {

    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
