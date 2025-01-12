//
//  View+Extension.swift
//  PeepIt
//
//  Created by 김민 on 11/26/24.
//

import SwiftUI

extension View {

    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func safeAreaTopInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return 0
        }

        return window.safeAreaInsets.top
    }
}
