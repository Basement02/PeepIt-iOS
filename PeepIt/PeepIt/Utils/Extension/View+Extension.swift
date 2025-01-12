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
        let statusHeight = UIApplication.shared.statusBarFrame.size.height  

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            return topPadding ?? statusHeight
        } else {
            return statusHeight
        }
    }
}
