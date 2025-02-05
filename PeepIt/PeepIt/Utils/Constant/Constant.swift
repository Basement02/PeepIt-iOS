//
//  Constant.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import UIKit

struct Constant {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    static var safeAreaInsets: UIEdgeInsets {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first { $0.isKeyWindow } }
            .first
        return keyWindow?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    static var safeAreaTop: CGFloat { safeAreaInsets.top }
    static var safeAreaBottom: CGFloat { safeAreaInsets.bottom }
}
