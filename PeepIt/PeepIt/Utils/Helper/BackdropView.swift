//
//  BackdropView.swift
//  PeepIt
//
//  Created by 김민 on 1/21/25.
//

import UIKit
import SwiftUI

struct BackdropView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

/// 배경 블러 처리 뷰
struct BackdropBlurView: View {

    let bgColor: Color
    let radius: CGFloat
    
    @ViewBuilder
    var body: some View {
        ZStack {
            bgColor
            BackdropView()
                .blur(radius: radius)
        }
    }
}
