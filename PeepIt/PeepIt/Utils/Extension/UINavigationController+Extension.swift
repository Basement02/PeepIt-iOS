//
//  UINavigationController+Extension.swift
//  PeepIt
//
//  Created by 김민 on 10/30/24.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return viewControllers.count > 1
    }
}
