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

    func captureAsImage(size: CGSize) -> UIImage? {
        // SwiftUI 뷰를 UIHostingController로 감싸서 UIView로 변환
        let hostingController = UIHostingController(rootView: self)
        let view = hostingController.view

        // 뷰의 크기를 설정
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear

        // 렌더링하여 UIImage로 변환
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}
