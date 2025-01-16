//
//  KeyboardToolbarView.swift
//  PeepIt
//
//  Created by 김민 on 12/26/24.
//

import Foundation
import SwiftUI

struct KeyboardToolbarView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        UIToolbar.appearance().standardAppearance = appearance
        UIToolbar.appearance().scrollEdgeAppearance = appearance

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
