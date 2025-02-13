//
//  KeyboardHeightDetector.swift
//  PeepIt
//
//  Created by 김민 on 2/5/25.
//

import SwiftUI

struct KeyboardHeightDetector: ViewModifier {
    @Binding var height: CGFloat

    init() {
        self._height = .constant(0)
    }

    init(_ height: Binding<CGFloat>) {
        self._height = height
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, height)
            .edgesIgnoringSafeArea(height == 0 ? Edge.Set() : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private func subscribeToKeyboardEvents() {
        _ = KeyboardHeightDetector.visibleHeight
            .subscribe(on: RunLoop.main)
            .assign(to: \.height, on: self)
    }
}

extension KeyboardHeightDetector {
    
    static let visibleHeight = keyboardWillOpen.merge(with: keyboardWillHide)

    static let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
        .map { $0.height }

    static let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat(0) }
}
